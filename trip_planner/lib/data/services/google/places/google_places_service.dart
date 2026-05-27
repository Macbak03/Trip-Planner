import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:trip_planner/domain/models/place/place.dart';
import 'package:trip_planner/domain/models/place/place_review.dart';
import 'package:trip_planner/domain/models/place/place_suggestion.dart';

/// REST client for Google Places API (New) v1.
/// Docs: https://developers.google.com/maps/documentation/places/web-service/op-overview
class GooglePlacesService {
  GooglePlacesService({http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final http.Client _http;
  final _log = Logger('GooglePlacesService');

  static const _base = 'https://places.googleapis.com/v1';

  String get _apiKey {
    final dedicated = dotenv.maybeGet('GOOGLE_PLACES_API_KEY');
    if (dedicated != null && dedicated.isNotEmpty) return dedicated;
    if (kIsWeb) {
      return dotenv.maybeGet('GOOGLE_MAPS_API_KEY') ?? '';
    }
    if (Platform.isAndroid) {
      return dotenv.maybeGet('GOOGLE_MAPS_ANDROID_API_KEY') ?? '';
    }
    if (Platform.isIOS) {
      return dotenv.maybeGet('GOOGLE_MAPS_IOS_API_KEY') ?? '';
    }
    return dotenv.maybeGet('GOOGLE_MAPS_API_KEY') ?? '';
  }

  Map<String, String> _headers({required String fieldMask}) => {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': _apiKey,
    'X-Goog-FieldMask': fieldMask,
  };

  Future<List<PlaceSuggestion>> autocomplete(
    String query, {
    required String sessionToken,
    GeoCoordinates? biasLocation,
    double biasRadiusMeters = 50000,
    List<String> includedPrimaryTypes = const <String>[],
  }) async {
    if (query.trim().isEmpty) return const <PlaceSuggestion>[];
    final uri = Uri.parse('$_base/places:autocomplete');
    final body = <String, dynamic>{
      'input': query,
      'sessionToken': sessionToken,
      if (includedPrimaryTypes.isNotEmpty)
        'includedPrimaryTypes': includedPrimaryTypes,
      if (biasLocation != null)
        'locationBias': {
          'circle': {
            'center': {
              'latitude': biasLocation.latitude,
              'longitude': biasLocation.longitude,
            },
            'radius': biasRadiusMeters,
          },
        },
    };
    final res = await _http.post(
      uri,
      headers: _headers(
        fieldMask:
            'suggestions.placePrediction.placeId,'
            'suggestions.placePrediction.structuredFormat,'
            'suggestions.placePrediction.types',
      ),
      body: jsonEncode(body),
    );
    if (res.statusCode != 200) {
      _log.warning('autocomplete failed ${res.statusCode}: ${res.body}');
      throw Exception('Places autocomplete failed: ${res.statusCode}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final suggestions = (data['suggestions'] as List<dynamic>? ?? const [])
        .map((s) => _parseSuggestion(s as Map<String, dynamic>))
        .whereType<PlaceSuggestion>()
        .toList();
    return suggestions;
  }

  PlaceSuggestion? _parseSuggestion(Map<String, dynamic> json) {
    final pred = json['placePrediction'] as Map<String, dynamic>?;
    if (pred == null) return null;
    final placeId = pred['placeId'] as String?;
    if (placeId == null) return null;
    final structured = pred['structuredFormat'] as Map<String, dynamic>?;
    final main = (structured?['mainText'] as Map<String, dynamic>?)?['text']
        as String?;
    final secondary =
        (structured?['secondaryText'] as Map<String, dynamic>?)?['text']
            as String?;
    final types = (pred['types'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList();
    return PlaceSuggestion(
      placeId: placeId,
      mainText: main ?? '',
      secondaryText: secondary ?? '',
      types: types,
    );
  }

  static const String _defaultPlaceFields =
      'id,displayName,formattedAddress,location,types,rating,'
      'userRatingCount,priceLevel,photos,regularOpeningHours,'
      'internationalPhoneNumber,websiteUri';

  /// Extended field mask for full place details: adds `reviews` which are
  /// expensive enough that we don't want them on list endpoints.
  static const String _detailsPlaceFields = '$_defaultPlaceFields,reviews';

  Future<Place> getDetails(
    String placeId, {
    String? sessionToken,
    String fields = _detailsPlaceFields,
  }) async {
    final uri = Uri.parse(
      '$_base/places/$placeId'
      '${sessionToken != null ? '?sessionToken=$sessionToken' : ''}',
    );
    final res = await _http.get(uri, headers: _headers(fieldMask: fields));
    if (res.statusCode != 200) {
      _log.warning('getDetails failed ${res.statusCode}: ${res.body}');
      throw Exception('Places getDetails failed: ${res.statusCode}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return _parsePlace(data);
  }

  Future<List<Place>> searchNearby({
    required GeoCoordinates location,
    required double radiusMeters,
    List<String> includedTypes = const <String>[],
    int maxResultCount = 10,
    bool rankByDistance = false,
  }) async {
    final uri = Uri.parse('$_base/places:searchNearby');
    final body = <String, dynamic>{
      'maxResultCount': maxResultCount,
      'locationRestriction': {
        'circle': {
          'center': {
            'latitude': location.latitude,
            'longitude': location.longitude,
          },
          'radius': radiusMeters,
        },
      },
      if (includedTypes.isNotEmpty) 'includedTypes': includedTypes,
      if (rankByDistance) 'rankPreference': 'DISTANCE',
    };
    final res = await _http.post(
      uri,
      headers: _headers(
        fieldMask:
            'places.${_defaultPlaceFields.split(',').join(',places.')}',
      ),
      body: jsonEncode(body),
    );
    if (res.statusCode != 200) {
      _log.warning('searchNearby failed ${res.statusCode}: ${res.body}');
      throw Exception('Places searchNearby failed: ${res.statusCode}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final places = (data['places'] as List<dynamic>? ?? const [])
        .map((p) => _parsePlace(p as Map<String, dynamic>))
        .toList();
    return places;
  }

  Future<List<Place>> searchText(
    String query, {
    List<String> includedTypes = const <String>[],
    GeoCoordinates? biasLocation,
    double biasRadiusMeters = 50000,
    int maxResultCount = 10,
    bool restrictLocation = false,
  }) async {
    final uri = Uri.parse('$_base/places:searchText');
    final body = <String, dynamic>{
      'textQuery': query,
      'maxResultCount': maxResultCount,
      if (includedTypes.isNotEmpty) 'includedType': includedTypes.first,
    };
    if (biasLocation != null) {
      if (restrictLocation) {
        // Text Search (New) accepts only `rectangle` for locationRestriction
        // (circle is bias-only). Convert the radius into a rectangle around
        // the centre point.
        final dLat = biasRadiusMeters / 111000.0;
        final cosLat = math
            .cos(biasLocation.latitude * math.pi / 180.0)
            .abs();
        final dLng = biasRadiusMeters / (111000.0 * (cosLat < 0.01 ? 0.01 : cosLat));
        body['locationRestriction'] = {
          'rectangle': {
            'low': {
              'latitude': biasLocation.latitude - dLat,
              'longitude': biasLocation.longitude - dLng,
            },
            'high': {
              'latitude': biasLocation.latitude + dLat,
              'longitude': biasLocation.longitude + dLng,
            },
          },
        };
      } else {
        body['locationBias'] = {
          'circle': {
            'center': {
              'latitude': biasLocation.latitude,
              'longitude': biasLocation.longitude,
            },
            'radius': biasRadiusMeters,
          },
        };
      }
    }
    final res = await _http.post(
      uri,
      headers: _headers(
        fieldMask:
            'places.${_defaultPlaceFields.split(',').join(',places.')}',
      ),
      body: jsonEncode(body),
    );
    if (res.statusCode != 200) {
      _log.warning('searchText failed ${res.statusCode}: ${res.body}');
      throw Exception('Places searchText failed: ${res.statusCode}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final places = (data['places'] as List<dynamic>? ?? const [])
        .map((p) => _parsePlace(p as Map<String, dynamic>))
        .toList();
    return places;
  }

  /// Builds a Places Photo (New) media URL. `name` is the full photo resource
  /// `places/{placeId}/photos/{photoRef}` returned from a details/search call.
  String photoUrl(String name, {int maxWidthPx = 800}) {
    return '$_base/$name/media'
        '?maxWidthPx=$maxWidthPx&key=$_apiKey';
  }

  Place _parsePlace(Map<String, dynamic> json) {
    final displayName =
        (json['displayName'] as Map<String, dynamic>?)?['text'] as String? ??
        '';
    final loc = json['location'] as Map<String, dynamic>?;
    final location = loc == null
        ? null
        : GeoCoordinates(
            latitude: (loc['latitude'] as num).toDouble(),
            longitude: (loc['longitude'] as num).toDouble(),
          );
    final types = (json['types'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList();
    final photoRefs = (json['photos'] as List<dynamic>? ?? const [])
        .map((p) => (p as Map<String, dynamic>)['name'] as String?)
        .whereType<String>()
        .toList();
    final hours = json['regularOpeningHours'] as Map<String, dynamic>?;
    final openingHours = hours == null
        ? null
        : OpeningHours(
            openNow: hours['openNow'] as bool?,
            weekdayDescriptions:
                (hours['weekdayDescriptions'] as List<dynamic>? ?? const [])
                    .whereType<String>()
                    .toList(),
          );
    final priceLevelRaw = json['priceLevel'];
    final priceLevel = priceLevelRaw is int
        ? priceLevelRaw
        : (priceLevelRaw is String ? _priceLevelFromString(priceLevelRaw) : null);
    final reviews = (json['reviews'] as List<dynamic>? ?? const [])
        .map((r) => _parseReview(r as Map<String, dynamic>))
        .whereType<PlaceReview>()
        .toList();
    return Place(
      id: json['id'] as String? ?? '',
      displayName: displayName,
      formattedAddress: json['formattedAddress'] as String?,
      location: location,
      types: types,
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingsTotal: (json['userRatingCount'] as num?)?.toInt(),
      priceLevel: priceLevel,
      photoRefs: photoRefs,
      openingHours: openingHours,
      internationalPhoneNumber: json['internationalPhoneNumber'] as String?,
      websiteUri: json['websiteUri'] as String?,
      reviews: reviews,
    );
  }

  PlaceReview? _parseReview(Map<String, dynamic> json) {
    final author = json['authorAttribution'] as Map<String, dynamic>?;
    final authorName = author?['displayName'] as String?;
    if (authorName == null || authorName.isEmpty) return null;
    final ratingRaw = json['rating'];
    final rating = ratingRaw is num ? ratingRaw.toDouble() : 0.0;
    final textObj = json['text'] as Map<String, dynamic>?;
    final text = textObj?['text'] as String? ?? '';
    final language = textObj?['languageCode'] as String?;
    final publishTime = json['publishTime'] as String?;
    DateTime? publishedAt;
    if (publishTime != null) {
      publishedAt = DateTime.tryParse(publishTime);
    }
    return PlaceReview(
      authorName: authorName,
      authorAvatarUrl: author?['photoUri'] as String?,
      rating: rating,
      text: text,
      publishedAt: publishedAt,
      language: language,
      relativeTime: json['relativePublishTimeDescription'] as String?,
    );
  }

  int? _priceLevelFromString(String value) {
    switch (value) {
      case 'PRICE_LEVEL_FREE':
        return 0;
      case 'PRICE_LEVEL_INEXPENSIVE':
        return 1;
      case 'PRICE_LEVEL_MODERATE':
        return 2;
      case 'PRICE_LEVEL_EXPENSIVE':
        return 3;
      case 'PRICE_LEVEL_VERY_EXPENSIVE':
        return 4;
      default:
        return null;
    }
  }

  void dispose() {
    _http.close();
  }
}
