import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trip_planner/data/services/firestore/timestamp_converter.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

@freezed
abstract class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String ownerId,
    required String destination,
    String? destinationPlaceId,
    required double budget,
    @Default('PLN') String currency,
    @TimestampConverter() required DateTime startDate,
    @TimestampConverter() required DateTime endDate,
    @TimestampConverter() required DateTime createdAt,
    String? coverImageUrl,
    @Default(<String>[]) List<String> placeIds,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}
