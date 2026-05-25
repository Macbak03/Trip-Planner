// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Trip _$TripFromJson(Map<String, dynamic> json) => _Trip(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  destination: json['destination'] as String,
  destinationPlaceId: json['destinationPlaceId'] as String?,
  budget: (json['budget'] as num).toDouble(),
  currency: json['currency'] as String? ?? 'PLN',
  startDate: const TimestampConverter().fromJson(json['startDate']),
  endDate: const TimestampConverter().fromJson(json['endDate']),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  coverImageUrl: json['coverImageUrl'] as String?,
  placeIds:
      (json['placeIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$TripToJson(_Trip instance) => <String, dynamic>{
  'id': instance.id,
  'ownerId': instance.ownerId,
  'destination': instance.destination,
  'destinationPlaceId': instance.destinationPlaceId,
  'budget': instance.budget,
  'currency': instance.currency,
  'startDate': const TimestampConverter().toJson(instance.startDate),
  'endDate': const TimestampConverter().toJson(instance.endDate),
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'coverImageUrl': instance.coverImageUrl,
  'placeIds': instance.placeIds,
};
