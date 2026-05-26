import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trip_planner/data/services/firestore/timestamp_converter.dart';
import 'package:trip_planner/domain/models/place/place.dart';

part 'trip_place.freezed.dart';
part 'trip_place.g.dart';

@freezed
abstract class TripPlace with _$TripPlace {
  const factory TripPlace({
    required String id,
    required String placeId,
    required int dayIndex,
    required int order,
    required String displayName,
    GeoCoordinates? location,
    double? distanceFromPrevKm,
    @TimestampConverter() required DateTime addedAt,
  }) = _TripPlace;

  factory TripPlace.fromJson(Map<String, dynamic> json) =>
      _$TripPlaceFromJson(json);
}
