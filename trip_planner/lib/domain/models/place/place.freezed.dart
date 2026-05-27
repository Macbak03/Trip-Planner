// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeoCoordinates {

 double get latitude; double get longitude;
/// Create a copy of GeoCoordinates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoCoordinatesCopyWith<GeoCoordinates> get copyWith => _$GeoCoordinatesCopyWithImpl<GeoCoordinates>(this as GeoCoordinates, _$identity);

  /// Serializes this GeoCoordinates to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoCoordinates&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'GeoCoordinates(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $GeoCoordinatesCopyWith<$Res>  {
  factory $GeoCoordinatesCopyWith(GeoCoordinates value, $Res Function(GeoCoordinates) _then) = _$GeoCoordinatesCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$GeoCoordinatesCopyWithImpl<$Res>
    implements $GeoCoordinatesCopyWith<$Res> {
  _$GeoCoordinatesCopyWithImpl(this._self, this._then);

  final GeoCoordinates _self;
  final $Res Function(GeoCoordinates) _then;

/// Create a copy of GeoCoordinates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoCoordinates].
extension GeoCoordinatesPatterns on GeoCoordinates {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoCoordinates value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoCoordinates() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoCoordinates value)  $default,){
final _that = this;
switch (_that) {
case _GeoCoordinates():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoCoordinates value)?  $default,){
final _that = this;
switch (_that) {
case _GeoCoordinates() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoCoordinates() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _GeoCoordinates():
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _GeoCoordinates() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoCoordinates implements GeoCoordinates {
  const _GeoCoordinates({required this.latitude, required this.longitude});
  factory _GeoCoordinates.fromJson(Map<String, dynamic> json) => _$GeoCoordinatesFromJson(json);

@override final  double latitude;
@override final  double longitude;

/// Create a copy of GeoCoordinates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoCoordinatesCopyWith<_GeoCoordinates> get copyWith => __$GeoCoordinatesCopyWithImpl<_GeoCoordinates>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoCoordinatesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoCoordinates&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'GeoCoordinates(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$GeoCoordinatesCopyWith<$Res> implements $GeoCoordinatesCopyWith<$Res> {
  factory _$GeoCoordinatesCopyWith(_GeoCoordinates value, $Res Function(_GeoCoordinates) _then) = __$GeoCoordinatesCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$GeoCoordinatesCopyWithImpl<$Res>
    implements _$GeoCoordinatesCopyWith<$Res> {
  __$GeoCoordinatesCopyWithImpl(this._self, this._then);

  final _GeoCoordinates _self;
  final $Res Function(_GeoCoordinates) _then;

/// Create a copy of GeoCoordinates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_GeoCoordinates(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$OpeningHours {

 bool? get openNow; List<String> get weekdayDescriptions;
/// Create a copy of OpeningHours
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpeningHoursCopyWith<OpeningHours> get copyWith => _$OpeningHoursCopyWithImpl<OpeningHours>(this as OpeningHours, _$identity);

  /// Serializes this OpeningHours to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpeningHours&&(identical(other.openNow, openNow) || other.openNow == openNow)&&const DeepCollectionEquality().equals(other.weekdayDescriptions, weekdayDescriptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,openNow,const DeepCollectionEquality().hash(weekdayDescriptions));

@override
String toString() {
  return 'OpeningHours(openNow: $openNow, weekdayDescriptions: $weekdayDescriptions)';
}


}

/// @nodoc
abstract mixin class $OpeningHoursCopyWith<$Res>  {
  factory $OpeningHoursCopyWith(OpeningHours value, $Res Function(OpeningHours) _then) = _$OpeningHoursCopyWithImpl;
@useResult
$Res call({
 bool? openNow, List<String> weekdayDescriptions
});




}
/// @nodoc
class _$OpeningHoursCopyWithImpl<$Res>
    implements $OpeningHoursCopyWith<$Res> {
  _$OpeningHoursCopyWithImpl(this._self, this._then);

  final OpeningHours _self;
  final $Res Function(OpeningHours) _then;

/// Create a copy of OpeningHours
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? openNow = freezed,Object? weekdayDescriptions = null,}) {
  return _then(_self.copyWith(
openNow: freezed == openNow ? _self.openNow : openNow // ignore: cast_nullable_to_non_nullable
as bool?,weekdayDescriptions: null == weekdayDescriptions ? _self.weekdayDescriptions : weekdayDescriptions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [OpeningHours].
extension OpeningHoursPatterns on OpeningHours {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpeningHours value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpeningHours() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpeningHours value)  $default,){
final _that = this;
switch (_that) {
case _OpeningHours():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpeningHours value)?  $default,){
final _that = this;
switch (_that) {
case _OpeningHours() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? openNow,  List<String> weekdayDescriptions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpeningHours() when $default != null:
return $default(_that.openNow,_that.weekdayDescriptions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? openNow,  List<String> weekdayDescriptions)  $default,) {final _that = this;
switch (_that) {
case _OpeningHours():
return $default(_that.openNow,_that.weekdayDescriptions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? openNow,  List<String> weekdayDescriptions)?  $default,) {final _that = this;
switch (_that) {
case _OpeningHours() when $default != null:
return $default(_that.openNow,_that.weekdayDescriptions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpeningHours implements OpeningHours {
  const _OpeningHours({this.openNow, final  List<String> weekdayDescriptions = const <String>[]}): _weekdayDescriptions = weekdayDescriptions;
  factory _OpeningHours.fromJson(Map<String, dynamic> json) => _$OpeningHoursFromJson(json);

@override final  bool? openNow;
 final  List<String> _weekdayDescriptions;
@override@JsonKey() List<String> get weekdayDescriptions {
  if (_weekdayDescriptions is EqualUnmodifiableListView) return _weekdayDescriptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdayDescriptions);
}


/// Create a copy of OpeningHours
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpeningHoursCopyWith<_OpeningHours> get copyWith => __$OpeningHoursCopyWithImpl<_OpeningHours>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpeningHoursToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpeningHours&&(identical(other.openNow, openNow) || other.openNow == openNow)&&const DeepCollectionEquality().equals(other._weekdayDescriptions, _weekdayDescriptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,openNow,const DeepCollectionEquality().hash(_weekdayDescriptions));

@override
String toString() {
  return 'OpeningHours(openNow: $openNow, weekdayDescriptions: $weekdayDescriptions)';
}


}

/// @nodoc
abstract mixin class _$OpeningHoursCopyWith<$Res> implements $OpeningHoursCopyWith<$Res> {
  factory _$OpeningHoursCopyWith(_OpeningHours value, $Res Function(_OpeningHours) _then) = __$OpeningHoursCopyWithImpl;
@override @useResult
$Res call({
 bool? openNow, List<String> weekdayDescriptions
});




}
/// @nodoc
class __$OpeningHoursCopyWithImpl<$Res>
    implements _$OpeningHoursCopyWith<$Res> {
  __$OpeningHoursCopyWithImpl(this._self, this._then);

  final _OpeningHours _self;
  final $Res Function(_OpeningHours) _then;

/// Create a copy of OpeningHours
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? openNow = freezed,Object? weekdayDescriptions = null,}) {
  return _then(_OpeningHours(
openNow: freezed == openNow ? _self.openNow : openNow // ignore: cast_nullable_to_non_nullable
as bool?,weekdayDescriptions: null == weekdayDescriptions ? _self._weekdayDescriptions : weekdayDescriptions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$Place {

 String get id; String get displayName; String? get formattedAddress; GeoCoordinates? get location; List<String> get types; double? get rating; int? get userRatingsTotal; int? get priceLevel; List<String> get photoRefs; OpeningHours? get openingHours; String? get internationalPhoneNumber; String? get websiteUri; List<PlaceReview> get reviews;
/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceCopyWith<Place> get copyWith => _$PlaceCopyWithImpl<Place>(this as Place, _$identity);

  /// Serializes this Place to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Place&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.formattedAddress, formattedAddress) || other.formattedAddress == formattedAddress)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.types, types)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.userRatingsTotal, userRatingsTotal) || other.userRatingsTotal == userRatingsTotal)&&(identical(other.priceLevel, priceLevel) || other.priceLevel == priceLevel)&&const DeepCollectionEquality().equals(other.photoRefs, photoRefs)&&(identical(other.openingHours, openingHours) || other.openingHours == openingHours)&&(identical(other.internationalPhoneNumber, internationalPhoneNumber) || other.internationalPhoneNumber == internationalPhoneNumber)&&(identical(other.websiteUri, websiteUri) || other.websiteUri == websiteUri)&&const DeepCollectionEquality().equals(other.reviews, reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,formattedAddress,location,const DeepCollectionEquality().hash(types),rating,userRatingsTotal,priceLevel,const DeepCollectionEquality().hash(photoRefs),openingHours,internationalPhoneNumber,websiteUri,const DeepCollectionEquality().hash(reviews));

@override
String toString() {
  return 'Place(id: $id, displayName: $displayName, formattedAddress: $formattedAddress, location: $location, types: $types, rating: $rating, userRatingsTotal: $userRatingsTotal, priceLevel: $priceLevel, photoRefs: $photoRefs, openingHours: $openingHours, internationalPhoneNumber: $internationalPhoneNumber, websiteUri: $websiteUri, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class $PlaceCopyWith<$Res>  {
  factory $PlaceCopyWith(Place value, $Res Function(Place) _then) = _$PlaceCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String? formattedAddress, GeoCoordinates? location, List<String> types, double? rating, int? userRatingsTotal, int? priceLevel, List<String> photoRefs, OpeningHours? openingHours, String? internationalPhoneNumber, String? websiteUri, List<PlaceReview> reviews
});


$GeoCoordinatesCopyWith<$Res>? get location;$OpeningHoursCopyWith<$Res>? get openingHours;

}
/// @nodoc
class _$PlaceCopyWithImpl<$Res>
    implements $PlaceCopyWith<$Res> {
  _$PlaceCopyWithImpl(this._self, this._then);

  final Place _self;
  final $Res Function(Place) _then;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? formattedAddress = freezed,Object? location = freezed,Object? types = null,Object? rating = freezed,Object? userRatingsTotal = freezed,Object? priceLevel = freezed,Object? photoRefs = null,Object? openingHours = freezed,Object? internationalPhoneNumber = freezed,Object? websiteUri = freezed,Object? reviews = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,formattedAddress: freezed == formattedAddress ? _self.formattedAddress : formattedAddress // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoCoordinates?,types: null == types ? _self.types : types // ignore: cast_nullable_to_non_nullable
as List<String>,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,userRatingsTotal: freezed == userRatingsTotal ? _self.userRatingsTotal : userRatingsTotal // ignore: cast_nullable_to_non_nullable
as int?,priceLevel: freezed == priceLevel ? _self.priceLevel : priceLevel // ignore: cast_nullable_to_non_nullable
as int?,photoRefs: null == photoRefs ? _self.photoRefs : photoRefs // ignore: cast_nullable_to_non_nullable
as List<String>,openingHours: freezed == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as OpeningHours?,internationalPhoneNumber: freezed == internationalPhoneNumber ? _self.internationalPhoneNumber : internationalPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,websiteUri: freezed == websiteUri ? _self.websiteUri : websiteUri // ignore: cast_nullable_to_non_nullable
as String?,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<PlaceReview>,
  ));
}
/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoCoordinatesCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $GeoCoordinatesCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpeningHoursCopyWith<$Res>? get openingHours {
    if (_self.openingHours == null) {
    return null;
  }

  return $OpeningHoursCopyWith<$Res>(_self.openingHours!, (value) {
    return _then(_self.copyWith(openingHours: value));
  });
}
}


/// Adds pattern-matching-related methods to [Place].
extension PlacePatterns on Place {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Place value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Place() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Place value)  $default,){
final _that = this;
switch (_that) {
case _Place():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Place value)?  $default,){
final _that = this;
switch (_that) {
case _Place() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  String? formattedAddress,  GeoCoordinates? location,  List<String> types,  double? rating,  int? userRatingsTotal,  int? priceLevel,  List<String> photoRefs,  OpeningHours? openingHours,  String? internationalPhoneNumber,  String? websiteUri,  List<PlaceReview> reviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that.id,_that.displayName,_that.formattedAddress,_that.location,_that.types,_that.rating,_that.userRatingsTotal,_that.priceLevel,_that.photoRefs,_that.openingHours,_that.internationalPhoneNumber,_that.websiteUri,_that.reviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  String? formattedAddress,  GeoCoordinates? location,  List<String> types,  double? rating,  int? userRatingsTotal,  int? priceLevel,  List<String> photoRefs,  OpeningHours? openingHours,  String? internationalPhoneNumber,  String? websiteUri,  List<PlaceReview> reviews)  $default,) {final _that = this;
switch (_that) {
case _Place():
return $default(_that.id,_that.displayName,_that.formattedAddress,_that.location,_that.types,_that.rating,_that.userRatingsTotal,_that.priceLevel,_that.photoRefs,_that.openingHours,_that.internationalPhoneNumber,_that.websiteUri,_that.reviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  String? formattedAddress,  GeoCoordinates? location,  List<String> types,  double? rating,  int? userRatingsTotal,  int? priceLevel,  List<String> photoRefs,  OpeningHours? openingHours,  String? internationalPhoneNumber,  String? websiteUri,  List<PlaceReview> reviews)?  $default,) {final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that.id,_that.displayName,_that.formattedAddress,_that.location,_that.types,_that.rating,_that.userRatingsTotal,_that.priceLevel,_that.photoRefs,_that.openingHours,_that.internationalPhoneNumber,_that.websiteUri,_that.reviews);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Place implements Place {
  const _Place({required this.id, required this.displayName, this.formattedAddress, this.location, final  List<String> types = const <String>[], this.rating, this.userRatingsTotal, this.priceLevel, final  List<String> photoRefs = const <String>[], this.openingHours, this.internationalPhoneNumber, this.websiteUri, final  List<PlaceReview> reviews = const <PlaceReview>[]}): _types = types,_photoRefs = photoRefs,_reviews = reviews;
  factory _Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

@override final  String id;
@override final  String displayName;
@override final  String? formattedAddress;
@override final  GeoCoordinates? location;
 final  List<String> _types;
@override@JsonKey() List<String> get types {
  if (_types is EqualUnmodifiableListView) return _types;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_types);
}

@override final  double? rating;
@override final  int? userRatingsTotal;
@override final  int? priceLevel;
 final  List<String> _photoRefs;
@override@JsonKey() List<String> get photoRefs {
  if (_photoRefs is EqualUnmodifiableListView) return _photoRefs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoRefs);
}

@override final  OpeningHours? openingHours;
@override final  String? internationalPhoneNumber;
@override final  String? websiteUri;
 final  List<PlaceReview> _reviews;
@override@JsonKey() List<PlaceReview> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}


/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceCopyWith<_Place> get copyWith => __$PlaceCopyWithImpl<_Place>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Place&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.formattedAddress, formattedAddress) || other.formattedAddress == formattedAddress)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other._types, _types)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.userRatingsTotal, userRatingsTotal) || other.userRatingsTotal == userRatingsTotal)&&(identical(other.priceLevel, priceLevel) || other.priceLevel == priceLevel)&&const DeepCollectionEquality().equals(other._photoRefs, _photoRefs)&&(identical(other.openingHours, openingHours) || other.openingHours == openingHours)&&(identical(other.internationalPhoneNumber, internationalPhoneNumber) || other.internationalPhoneNumber == internationalPhoneNumber)&&(identical(other.websiteUri, websiteUri) || other.websiteUri == websiteUri)&&const DeepCollectionEquality().equals(other._reviews, _reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,formattedAddress,location,const DeepCollectionEquality().hash(_types),rating,userRatingsTotal,priceLevel,const DeepCollectionEquality().hash(_photoRefs),openingHours,internationalPhoneNumber,websiteUri,const DeepCollectionEquality().hash(_reviews));

@override
String toString() {
  return 'Place(id: $id, displayName: $displayName, formattedAddress: $formattedAddress, location: $location, types: $types, rating: $rating, userRatingsTotal: $userRatingsTotal, priceLevel: $priceLevel, photoRefs: $photoRefs, openingHours: $openingHours, internationalPhoneNumber: $internationalPhoneNumber, websiteUri: $websiteUri, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class _$PlaceCopyWith<$Res> implements $PlaceCopyWith<$Res> {
  factory _$PlaceCopyWith(_Place value, $Res Function(_Place) _then) = __$PlaceCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String? formattedAddress, GeoCoordinates? location, List<String> types, double? rating, int? userRatingsTotal, int? priceLevel, List<String> photoRefs, OpeningHours? openingHours, String? internationalPhoneNumber, String? websiteUri, List<PlaceReview> reviews
});


@override $GeoCoordinatesCopyWith<$Res>? get location;@override $OpeningHoursCopyWith<$Res>? get openingHours;

}
/// @nodoc
class __$PlaceCopyWithImpl<$Res>
    implements _$PlaceCopyWith<$Res> {
  __$PlaceCopyWithImpl(this._self, this._then);

  final _Place _self;
  final $Res Function(_Place) _then;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? formattedAddress = freezed,Object? location = freezed,Object? types = null,Object? rating = freezed,Object? userRatingsTotal = freezed,Object? priceLevel = freezed,Object? photoRefs = null,Object? openingHours = freezed,Object? internationalPhoneNumber = freezed,Object? websiteUri = freezed,Object? reviews = null,}) {
  return _then(_Place(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,formattedAddress: freezed == formattedAddress ? _self.formattedAddress : formattedAddress // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoCoordinates?,types: null == types ? _self._types : types // ignore: cast_nullable_to_non_nullable
as List<String>,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,userRatingsTotal: freezed == userRatingsTotal ? _self.userRatingsTotal : userRatingsTotal // ignore: cast_nullable_to_non_nullable
as int?,priceLevel: freezed == priceLevel ? _self.priceLevel : priceLevel // ignore: cast_nullable_to_non_nullable
as int?,photoRefs: null == photoRefs ? _self._photoRefs : photoRefs // ignore: cast_nullable_to_non_nullable
as List<String>,openingHours: freezed == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as OpeningHours?,internationalPhoneNumber: freezed == internationalPhoneNumber ? _self.internationalPhoneNumber : internationalPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,websiteUri: freezed == websiteUri ? _self.websiteUri : websiteUri // ignore: cast_nullable_to_non_nullable
as String?,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<PlaceReview>,
  ));
}

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoCoordinatesCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $GeoCoordinatesCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpeningHoursCopyWith<$Res>? get openingHours {
    if (_self.openingHours == null) {
    return null;
  }

  return $OpeningHoursCopyWith<$Res>(_self.openingHours!, (value) {
    return _then(_self.copyWith(openingHours: value));
  });
}
}

// dart format on
