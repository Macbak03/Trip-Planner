import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

@freezed
abstract class GeoCoordinates with _$GeoCoordinates {
  const factory GeoCoordinates({
    required double latitude,
    required double longitude,
  }) = _GeoCoordinates;

  factory GeoCoordinates.fromJson(Map<String, dynamic> json) =>
      _$GeoCoordinatesFromJson(json);
}

@freezed
abstract class OpeningHours with _$OpeningHours {
  const factory OpeningHours({
    bool? openNow,
    @Default(<String>[]) List<String> weekdayDescriptions,
  }) = _OpeningHours;

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);
}

@freezed
abstract class Place with _$Place {
  const factory Place({
    required String id,
    required String displayName,
    String? formattedAddress,
    GeoCoordinates? location,
    @Default(<String>[]) List<String> types,
    double? rating,
    int? userRatingsTotal,
    int? priceLevel,
    @Default(<String>[]) List<String> photoRefs,
    OpeningHours? openingHours,
    String? internationalPhoneNumber,
    String? websiteUri,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}
