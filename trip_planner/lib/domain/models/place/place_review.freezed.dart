// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaceReview {

 String get authorName; String? get authorAvatarUrl; double get rating; String get text; DateTime? get publishedAt; String? get language; String? get relativeTime;
/// Create a copy of PlaceReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceReviewCopyWith<PlaceReview> get copyWith => _$PlaceReviewCopyWithImpl<PlaceReview>(this as PlaceReview, _$identity);

  /// Serializes this PlaceReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceReview&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorAvatarUrl, authorAvatarUrl) || other.authorAvatarUrl == authorAvatarUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.language, language) || other.language == language)&&(identical(other.relativeTime, relativeTime) || other.relativeTime == relativeTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,authorName,authorAvatarUrl,rating,text,publishedAt,language,relativeTime);

@override
String toString() {
  return 'PlaceReview(authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, rating: $rating, text: $text, publishedAt: $publishedAt, language: $language, relativeTime: $relativeTime)';
}


}

/// @nodoc
abstract mixin class $PlaceReviewCopyWith<$Res>  {
  factory $PlaceReviewCopyWith(PlaceReview value, $Res Function(PlaceReview) _then) = _$PlaceReviewCopyWithImpl;
@useResult
$Res call({
 String authorName, String? authorAvatarUrl, double rating, String text, DateTime? publishedAt, String? language, String? relativeTime
});




}
/// @nodoc
class _$PlaceReviewCopyWithImpl<$Res>
    implements $PlaceReviewCopyWith<$Res> {
  _$PlaceReviewCopyWithImpl(this._self, this._then);

  final PlaceReview _self;
  final $Res Function(PlaceReview) _then;

/// Create a copy of PlaceReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authorName = null,Object? authorAvatarUrl = freezed,Object? rating = null,Object? text = null,Object? publishedAt = freezed,Object? language = freezed,Object? relativeTime = freezed,}) {
  return _then(_self.copyWith(
authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorAvatarUrl: freezed == authorAvatarUrl ? _self.authorAvatarUrl : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,relativeTime: freezed == relativeTime ? _self.relativeTime : relativeTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaceReview].
extension PlaceReviewPatterns on PlaceReview {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaceReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaceReview() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaceReview value)  $default,){
final _that = this;
switch (_that) {
case _PlaceReview():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaceReview value)?  $default,){
final _that = this;
switch (_that) {
case _PlaceReview() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String authorName,  String? authorAvatarUrl,  double rating,  String text,  DateTime? publishedAt,  String? language,  String? relativeTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaceReview() when $default != null:
return $default(_that.authorName,_that.authorAvatarUrl,_that.rating,_that.text,_that.publishedAt,_that.language,_that.relativeTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String authorName,  String? authorAvatarUrl,  double rating,  String text,  DateTime? publishedAt,  String? language,  String? relativeTime)  $default,) {final _that = this;
switch (_that) {
case _PlaceReview():
return $default(_that.authorName,_that.authorAvatarUrl,_that.rating,_that.text,_that.publishedAt,_that.language,_that.relativeTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String authorName,  String? authorAvatarUrl,  double rating,  String text,  DateTime? publishedAt,  String? language,  String? relativeTime)?  $default,) {final _that = this;
switch (_that) {
case _PlaceReview() when $default != null:
return $default(_that.authorName,_that.authorAvatarUrl,_that.rating,_that.text,_that.publishedAt,_that.language,_that.relativeTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlaceReview implements PlaceReview {
  const _PlaceReview({required this.authorName, this.authorAvatarUrl, required this.rating, required this.text, this.publishedAt, this.language, this.relativeTime});
  factory _PlaceReview.fromJson(Map<String, dynamic> json) => _$PlaceReviewFromJson(json);

@override final  String authorName;
@override final  String? authorAvatarUrl;
@override final  double rating;
@override final  String text;
@override final  DateTime? publishedAt;
@override final  String? language;
@override final  String? relativeTime;

/// Create a copy of PlaceReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceReviewCopyWith<_PlaceReview> get copyWith => __$PlaceReviewCopyWithImpl<_PlaceReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaceReview&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorAvatarUrl, authorAvatarUrl) || other.authorAvatarUrl == authorAvatarUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.language, language) || other.language == language)&&(identical(other.relativeTime, relativeTime) || other.relativeTime == relativeTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,authorName,authorAvatarUrl,rating,text,publishedAt,language,relativeTime);

@override
String toString() {
  return 'PlaceReview(authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, rating: $rating, text: $text, publishedAt: $publishedAt, language: $language, relativeTime: $relativeTime)';
}


}

/// @nodoc
abstract mixin class _$PlaceReviewCopyWith<$Res> implements $PlaceReviewCopyWith<$Res> {
  factory _$PlaceReviewCopyWith(_PlaceReview value, $Res Function(_PlaceReview) _then) = __$PlaceReviewCopyWithImpl;
@override @useResult
$Res call({
 String authorName, String? authorAvatarUrl, double rating, String text, DateTime? publishedAt, String? language, String? relativeTime
});




}
/// @nodoc
class __$PlaceReviewCopyWithImpl<$Res>
    implements _$PlaceReviewCopyWith<$Res> {
  __$PlaceReviewCopyWithImpl(this._self, this._then);

  final _PlaceReview _self;
  final $Res Function(_PlaceReview) _then;

/// Create a copy of PlaceReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authorName = null,Object? authorAvatarUrl = freezed,Object? rating = null,Object? text = null,Object? publishedAt = freezed,Object? language = freezed,Object? relativeTime = freezed,}) {
  return _then(_PlaceReview(
authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorAvatarUrl: freezed == authorAvatarUrl ? _self.authorAvatarUrl : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,relativeTime: freezed == relativeTime ? _self.relativeTime : relativeTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
