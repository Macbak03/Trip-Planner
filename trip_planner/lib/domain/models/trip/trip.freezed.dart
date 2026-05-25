// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Trip {

 String get id; String get ownerId; String get destination; String? get destinationPlaceId; double get budget; String get currency;@TimestampConverter() DateTime get startDate;@TimestampConverter() DateTime get endDate;@TimestampConverter() DateTime get createdAt; String? get coverImageUrl; List<String> get placeIds;
/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripCopyWith<Trip> get copyWith => _$TripCopyWithImpl<Trip>(this as Trip, _$identity);

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Trip&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.destinationPlaceId, destinationPlaceId) || other.destinationPlaceId == destinationPlaceId)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other.placeIds, placeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,destination,destinationPlaceId,budget,currency,startDate,endDate,createdAt,coverImageUrl,const DeepCollectionEquality().hash(placeIds));

@override
String toString() {
  return 'Trip(id: $id, ownerId: $ownerId, destination: $destination, destinationPlaceId: $destinationPlaceId, budget: $budget, currency: $currency, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, coverImageUrl: $coverImageUrl, placeIds: $placeIds)';
}


}

/// @nodoc
abstract mixin class $TripCopyWith<$Res>  {
  factory $TripCopyWith(Trip value, $Res Function(Trip) _then) = _$TripCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, String destination, String? destinationPlaceId, double budget, String currency,@TimestampConverter() DateTime startDate,@TimestampConverter() DateTime endDate,@TimestampConverter() DateTime createdAt, String? coverImageUrl, List<String> placeIds
});




}
/// @nodoc
class _$TripCopyWithImpl<$Res>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._self, this._then);

  final Trip _self;
  final $Res Function(Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? destination = null,Object? destinationPlaceId = freezed,Object? budget = null,Object? currency = null,Object? startDate = null,Object? endDate = null,Object? createdAt = null,Object? coverImageUrl = freezed,Object? placeIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,destinationPlaceId: freezed == destinationPlaceId ? _self.destinationPlaceId : destinationPlaceId // ignore: cast_nullable_to_non_nullable
as String?,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,placeIds: null == placeIds ? _self.placeIds : placeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Trip].
extension TripPatterns on Trip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Trip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Trip value)  $default,){
final _that = this;
switch (_that) {
case _Trip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Trip value)?  $default,){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  String destination,  String? destinationPlaceId,  double budget,  String currency, @TimestampConverter()  DateTime startDate, @TimestampConverter()  DateTime endDate, @TimestampConverter()  DateTime createdAt,  String? coverImageUrl,  List<String> placeIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.ownerId,_that.destination,_that.destinationPlaceId,_that.budget,_that.currency,_that.startDate,_that.endDate,_that.createdAt,_that.coverImageUrl,_that.placeIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  String destination,  String? destinationPlaceId,  double budget,  String currency, @TimestampConverter()  DateTime startDate, @TimestampConverter()  DateTime endDate, @TimestampConverter()  DateTime createdAt,  String? coverImageUrl,  List<String> placeIds)  $default,) {final _that = this;
switch (_that) {
case _Trip():
return $default(_that.id,_that.ownerId,_that.destination,_that.destinationPlaceId,_that.budget,_that.currency,_that.startDate,_that.endDate,_that.createdAt,_that.coverImageUrl,_that.placeIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  String destination,  String? destinationPlaceId,  double budget,  String currency, @TimestampConverter()  DateTime startDate, @TimestampConverter()  DateTime endDate, @TimestampConverter()  DateTime createdAt,  String? coverImageUrl,  List<String> placeIds)?  $default,) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.ownerId,_that.destination,_that.destinationPlaceId,_that.budget,_that.currency,_that.startDate,_that.endDate,_that.createdAt,_that.coverImageUrl,_that.placeIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Trip implements Trip {
  const _Trip({required this.id, required this.ownerId, required this.destination, this.destinationPlaceId, required this.budget, this.currency = 'PLN', @TimestampConverter() required this.startDate, @TimestampConverter() required this.endDate, @TimestampConverter() required this.createdAt, this.coverImageUrl, final  List<String> placeIds = const <String>[]}): _placeIds = placeIds;
  factory _Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

@override final  String id;
@override final  String ownerId;
@override final  String destination;
@override final  String? destinationPlaceId;
@override final  double budget;
@override@JsonKey() final  String currency;
@override@TimestampConverter() final  DateTime startDate;
@override@TimestampConverter() final  DateTime endDate;
@override@TimestampConverter() final  DateTime createdAt;
@override final  String? coverImageUrl;
 final  List<String> _placeIds;
@override@JsonKey() List<String> get placeIds {
  if (_placeIds is EqualUnmodifiableListView) return _placeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_placeIds);
}


/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripCopyWith<_Trip> get copyWith => __$TripCopyWithImpl<_Trip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Trip&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.destinationPlaceId, destinationPlaceId) || other.destinationPlaceId == destinationPlaceId)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other._placeIds, _placeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,destination,destinationPlaceId,budget,currency,startDate,endDate,createdAt,coverImageUrl,const DeepCollectionEquality().hash(_placeIds));

@override
String toString() {
  return 'Trip(id: $id, ownerId: $ownerId, destination: $destination, destinationPlaceId: $destinationPlaceId, budget: $budget, currency: $currency, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, coverImageUrl: $coverImageUrl, placeIds: $placeIds)';
}


}

/// @nodoc
abstract mixin class _$TripCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$TripCopyWith(_Trip value, $Res Function(_Trip) _then) = __$TripCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, String destination, String? destinationPlaceId, double budget, String currency,@TimestampConverter() DateTime startDate,@TimestampConverter() DateTime endDate,@TimestampConverter() DateTime createdAt, String? coverImageUrl, List<String> placeIds
});




}
/// @nodoc
class __$TripCopyWithImpl<$Res>
    implements _$TripCopyWith<$Res> {
  __$TripCopyWithImpl(this._self, this._then);

  final _Trip _self;
  final $Res Function(_Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? destination = null,Object? destinationPlaceId = freezed,Object? budget = null,Object? currency = null,Object? startDate = null,Object? endDate = null,Object? createdAt = null,Object? coverImageUrl = freezed,Object? placeIds = null,}) {
  return _then(_Trip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,destinationPlaceId: freezed == destinationPlaceId ? _self.destinationPlaceId : destinationPlaceId // ignore: cast_nullable_to_non_nullable
as String?,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,placeIds: null == placeIds ? _self._placeIds : placeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
