import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_review.freezed.dart';
part 'place_review.g.dart';

@freezed
abstract class PlaceReview with _$PlaceReview {
  const factory PlaceReview({
    required String authorName,
    String? authorAvatarUrl,
    required double rating,
    required String text,
    DateTime? publishedAt,
    String? language,
    String? relativeTime,
  }) = _PlaceReview;

  factory PlaceReview.fromJson(Map<String, dynamic> json) =>
      _$PlaceReviewFromJson(json);
}
