// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TripPlace {

 String get id; String get placeId; int get dayIndex; int get order; String get displayName; GeoCoordinates? get location; double? get distanceFromPrevKm;@TimestampConverter() DateTime get addedAt;
/// Create a copy of TripPlace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripPlaceCopyWith<TripPlace> get copyWith => _$TripPlaceCopyWithImpl<TripPlace>(this as TripPlace, _$identity);

  /// Serializes this TripPlace to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripPlace&&(identical(other.id, id) || other.id == id)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&(identical(other.order, order) || other.order == order)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.location, location) || other.location == location)&&(identical(other.distanceFromPrevKm, distanceFromPrevKm) || other.distanceFromPrevKm == distanceFromPrevKm)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,placeId,dayIndex,order,displayName,location,distanceFromPrevKm,addedAt);

@override
String toString() {
  return 'TripPlace(id: $id, placeId: $placeId, dayIndex: $dayIndex, order: $order, displayName: $displayName, location: $location, distanceFromPrevKm: $distanceFromPrevKm, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $TripPlaceCopyWith<$Res>  {
  factory $TripPlaceCopyWith(TripPlace value, $Res Function(TripPlace) _then) = _$TripPlaceCopyWithImpl;
@useResult
$Res call({
 String id, String placeId, int dayIndex, int order, String displayName, GeoCoordinates? location, double? distanceFromPrevKm,@TimestampConverter() DateTime addedAt
});


$GeoCoordinatesCopyWith<$Res>? get location;

}
/// @nodoc
class _$TripPlaceCopyWithImpl<$Res>
    implements $TripPlaceCopyWith<$Res> {
  _$TripPlaceCopyWithImpl(this._self, this._then);

  final TripPlace _self;
  final $Res Function(TripPlace) _then;

/// Create a copy of TripPlace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? placeId = null,Object? dayIndex = null,Object? order = null,Object? displayName = null,Object? location = freezed,Object? distanceFromPrevKm = freezed,Object? addedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoCoordinates?,distanceFromPrevKm: freezed == distanceFromPrevKm ? _self.distanceFromPrevKm : distanceFromPrevKm // ignore: cast_nullable_to_non_nullable
as double?,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of TripPlace
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
}
}


/// Adds pattern-matching-related methods to [TripPlace].
extension TripPlacePatterns on TripPlace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripPlace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripPlace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripPlace value)  $default,){
final _that = this;
switch (_that) {
case _TripPlace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripPlace value)?  $default,){
final _that = this;
switch (_that) {
case _TripPlace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String placeId,  int dayIndex,  int order,  String displayName,  GeoCoordinates? location,  double? distanceFromPrevKm, @TimestampConverter()  DateTime addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripPlace() when $default != null:
return $default(_that.id,_that.placeId,_that.dayIndex,_that.order,_that.displayName,_that.location,_that.distanceFromPrevKm,_that.addedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String placeId,  int dayIndex,  int order,  String displayName,  GeoCoordinates? location,  double? distanceFromPrevKm, @TimestampConverter()  DateTime addedAt)  $default,) {final _that = this;
switch (_that) {
case _TripPlace():
return $default(_that.id,_that.placeId,_that.dayIndex,_that.order,_that.displayName,_that.location,_that.distanceFromPrevKm,_that.addedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String placeId,  int dayIndex,  int order,  String displayName,  GeoCoordinates? location,  double? distanceFromPrevKm, @TimestampConverter()  DateTime addedAt)?  $default,) {final _that = this;
switch (_that) {
case _TripPlace() when $default != null:
return $default(_that.id,_that.placeId,_that.dayIndex,_that.order,_that.displayName,_that.location,_that.distanceFromPrevKm,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripPlace implements TripPlace {
  const _TripPlace({required this.id, required this.placeId, required this.dayIndex, required this.order, required this.displayName, this.location, this.distanceFromPrevKm, @TimestampConverter() required this.addedAt});
  factory _TripPlace.fromJson(Map<String, dynamic> json) => _$TripPlaceFromJson(json);

@override final  String id;
@override final  String placeId;
@override final  int dayIndex;
@override final  int order;
@override final  String displayName;
@override final  GeoCoordinates? location;
@override final  double? distanceFromPrevKm;
@override@TimestampConverter() final  DateTime addedAt;

/// Create a copy of TripPlace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripPlaceCopyWith<_TripPlace> get copyWith => __$TripPlaceCopyWithImpl<_TripPlace>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripPlaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripPlace&&(identical(other.id, id) || other.id == id)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&(identical(other.order, order) || other.order == order)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.location, location) || other.location == location)&&(identical(other.distanceFromPrevKm, distanceFromPrevKm) || other.distanceFromPrevKm == distanceFromPrevKm)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,placeId,dayIndex,order,displayName,location,distanceFromPrevKm,addedAt);

@override
String toString() {
  return 'TripPlace(id: $id, placeId: $placeId, dayIndex: $dayIndex, order: $order, displayName: $displayName, location: $location, distanceFromPrevKm: $distanceFromPrevKm, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$TripPlaceCopyWith<$Res> implements $TripPlaceCopyWith<$Res> {
  factory _$TripPlaceCopyWith(_TripPlace value, $Res Function(_TripPlace) _then) = __$TripPlaceCopyWithImpl;
@override @useResult
$Res call({
 String id, String placeId, int dayIndex, int order, String displayName, GeoCoordinates? location, double? distanceFromPrevKm,@TimestampConverter() DateTime addedAt
});


@override $GeoCoordinatesCopyWith<$Res>? get location;

}
/// @nodoc
class __$TripPlaceCopyWithImpl<$Res>
    implements _$TripPlaceCopyWith<$Res> {
  __$TripPlaceCopyWithImpl(this._self, this._then);

  final _TripPlace _self;
  final $Res Function(_TripPlace) _then;

/// Create a copy of TripPlace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? placeId = null,Object? dayIndex = null,Object? order = null,Object? displayName = null,Object? location = freezed,Object? distanceFromPrevKm = freezed,Object? addedAt = null,}) {
  return _then(_TripPlace(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoCoordinates?,distanceFromPrevKm: freezed == distanceFromPrevKm ? _self.distanceFromPrevKm : distanceFromPrevKm // ignore: cast_nullable_to_non_nullable
as double?,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of TripPlace
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
}
}

// dart format on
