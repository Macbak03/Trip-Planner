// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TripPlace _$TripPlaceFromJson(Map<String, dynamic> json) => _TripPlace(
  id: json['id'] as String,
  placeId: json['placeId'] as String,
  dayIndex: (json['dayIndex'] as num).toInt(),
  order: (json['order'] as num).toInt(),
  displayName: json['displayName'] as String,
  location: json['location'] == null
      ? null
      : GeoCoordinates.fromJson(json['location'] as Map<String, dynamic>),
  distanceFromPrevKm: (json['distanceFromPrevKm'] as num?)?.toDouble(),
  addedAt: const TimestampConverter().fromJson(json['addedAt']),
);

Map<String, dynamic> _$TripPlaceToJson(_TripPlace instance) =>
    <String, dynamic>{
      'id': instance.id,
      'placeId': instance.placeId,
      'dayIndex': instance.dayIndex,
      'order': instance.order,
      'displayName': instance.displayName,
      'location': instance.location?.toJson(),
      'distanceFromPrevKm': instance.distanceFromPrevKm,
      'addedAt': const TimestampConverter().toJson(instance.addedAt),
    };
