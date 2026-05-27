// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlaceReview _$PlaceReviewFromJson(Map<String, dynamic> json) => _PlaceReview(
  authorName: json['authorName'] as String,
  authorAvatarUrl: json['authorAvatarUrl'] as String?,
  rating: (json['rating'] as num).toDouble(),
  text: json['text'] as String,
  publishedAt: json['publishedAt'] == null
      ? null
      : DateTime.parse(json['publishedAt'] as String),
  language: json['language'] as String?,
  relativeTime: json['relativeTime'] as String?,
);

Map<String, dynamic> _$PlaceReviewToJson(_PlaceReview instance) =>
    <String, dynamic>{
      'authorName': instance.authorName,
      'authorAvatarUrl': instance.authorAvatarUrl,
      'rating': instance.rating,
      'text': instance.text,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'language': instance.language,
      'relativeTime': instance.relativeTime,
    };
