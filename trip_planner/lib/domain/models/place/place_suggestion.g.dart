// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlaceSuggestion _$PlaceSuggestionFromJson(Map<String, dynamic> json) =>
    _PlaceSuggestion(
      placeId: json['placeId'] as String,
      mainText: json['mainText'] as String,
      secondaryText: json['secondaryText'] as String? ?? '',
      types:
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
    );

Map<String, dynamic> _$PlaceSuggestionToJson(_PlaceSuggestion instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'mainText': instance.mainText,
      'secondaryText': instance.secondaryText,
      'types': instance.types,
    };
