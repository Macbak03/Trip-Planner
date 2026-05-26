// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeoCoordinates _$GeoCoordinatesFromJson(Map<String, dynamic> json) =>
    _GeoCoordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$GeoCoordinatesToJson(_GeoCoordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) =>
    _OpeningHours(
      openNow: json['openNow'] as bool?,
      weekdayDescriptions:
          (json['weekdayDescriptions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$OpeningHoursToJson(_OpeningHours instance) =>
    <String, dynamic>{
      'openNow': instance.openNow,
      'weekdayDescriptions': instance.weekdayDescriptions,
    };

_Place _$PlaceFromJson(Map<String, dynamic> json) => _Place(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  formattedAddress: json['formattedAddress'] as String?,
  location: json['location'] == null
      ? null
      : GeoCoordinates.fromJson(json['location'] as Map<String, dynamic>),
  types:
      (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  rating: (json['rating'] as num?)?.toDouble(),
  userRatingsTotal: (json['userRatingsTotal'] as num?)?.toInt(),
  priceLevel: (json['priceLevel'] as num?)?.toInt(),
  photoRefs:
      (json['photoRefs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  openingHours: json['openingHours'] == null
      ? null
      : OpeningHours.fromJson(json['openingHours'] as Map<String, dynamic>),
  internationalPhoneNumber: json['internationalPhoneNumber'] as String?,
  websiteUri: json['websiteUri'] as String?,
);

Map<String, dynamic> _$PlaceToJson(_Place instance) => <String, dynamic>{
  'id': instance.id,
  'displayName': instance.displayName,
  'formattedAddress': instance.formattedAddress,
  'location': instance.location?.toJson(),
  'types': instance.types,
  'rating': instance.rating,
  'userRatingsTotal': instance.userRatingsTotal,
  'priceLevel': instance.priceLevel,
  'photoRefs': instance.photoRefs,
  'openingHours': instance.openingHours?.toJson(),
  'internationalPhoneNumber': instance.internationalPhoneNumber,
  'websiteUri': instance.websiteUri,
};
