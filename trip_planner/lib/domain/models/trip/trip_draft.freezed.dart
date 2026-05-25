// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TripDraft {

 String get destination; String? get destinationPlaceId; double? get budget; String get currency; DateTime? get startDate; DateTime? get endDate;
/// Create a copy of TripDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripDraftCopyWith<TripDraft> get copyWith => _$TripDraftCopyWithImpl<TripDraft>(this as TripDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripDraft&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.destinationPlaceId, destinationPlaceId) || other.destinationPlaceId == destinationPlaceId)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,destination,destinationPlaceId,budget,currency,startDate,endDate);

@override
String toString() {
  return 'TripDraft(destination: $destination, destinationPlaceId: $destinationPlaceId, budget: $budget, currency: $currency, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $TripDraftCopyWith<$Res>  {
  factory $TripDraftCopyWith(TripDraft value, $Res Function(TripDraft) _then) = _$TripDraftCopyWithImpl;
@useResult
$Res call({
 String destination, String? destinationPlaceId, double? budget, String currency, DateTime? startDate, DateTime? endDate
});




}
/// @nodoc
class _$TripDraftCopyWithImpl<$Res>
    implements $TripDraftCopyWith<$Res> {
  _$TripDraftCopyWithImpl(this._self, this._then);

  final TripDraft _self;
  final $Res Function(TripDraft) _then;

/// Create a copy of TripDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? destination = null,Object? destinationPlaceId = freezed,Object? budget = freezed,Object? currency = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_self.copyWith(
destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,destinationPlaceId: freezed == destinationPlaceId ? _self.destinationPlaceId : destinationPlaceId // ignore: cast_nullable_to_non_nullable
as String?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TripDraft].
extension TripDraftPatterns on TripDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripDraft value)  $default,){
final _that = this;
switch (_that) {
case _TripDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TripDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String destination,  String? destinationPlaceId,  double? budget,  String currency,  DateTime? startDate,  DateTime? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripDraft() when $default != null:
return $default(_that.destination,_that.destinationPlaceId,_that.budget,_that.currency,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String destination,  String? destinationPlaceId,  double? budget,  String currency,  DateTime? startDate,  DateTime? endDate)  $default,) {final _that = this;
switch (_that) {
case _TripDraft():
return $default(_that.destination,_that.destinationPlaceId,_that.budget,_that.currency,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String destination,  String? destinationPlaceId,  double? budget,  String currency,  DateTime? startDate,  DateTime? endDate)?  $default,) {final _that = this;
switch (_that) {
case _TripDraft() when $default != null:
return $default(_that.destination,_that.destinationPlaceId,_that.budget,_that.currency,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc


class _TripDraft implements TripDraft {
  const _TripDraft({this.destination = '', this.destinationPlaceId, this.budget, this.currency = 'PLN', this.startDate, this.endDate});
  

@override@JsonKey() final  String destination;
@override final  String? destinationPlaceId;
@override final  double? budget;
@override@JsonKey() final  String currency;
@override final  DateTime? startDate;
@override final  DateTime? endDate;

/// Create a copy of TripDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripDraftCopyWith<_TripDraft> get copyWith => __$TripDraftCopyWithImpl<_TripDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripDraft&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.destinationPlaceId, destinationPlaceId) || other.destinationPlaceId == destinationPlaceId)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,destination,destinationPlaceId,budget,currency,startDate,endDate);

@override
String toString() {
  return 'TripDraft(destination: $destination, destinationPlaceId: $destinationPlaceId, budget: $budget, currency: $currency, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$TripDraftCopyWith<$Res> implements $TripDraftCopyWith<$Res> {
  factory _$TripDraftCopyWith(_TripDraft value, $Res Function(_TripDraft) _then) = __$TripDraftCopyWithImpl;
@override @useResult
$Res call({
 String destination, String? destinationPlaceId, double? budget, String currency, DateTime? startDate, DateTime? endDate
});




}
/// @nodoc
class __$TripDraftCopyWithImpl<$Res>
    implements _$TripDraftCopyWith<$Res> {
  __$TripDraftCopyWithImpl(this._self, this._then);

  final _TripDraft _self;
  final $Res Function(_TripDraft) _then;

/// Create a copy of TripDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? destination = null,Object? destinationPlaceId = freezed,Object? budget = freezed,Object? currency = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_TripDraft(
destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,destinationPlaceId: freezed == destinationPlaceId ? _self.destinationPlaceId : destinationPlaceId // ignore: cast_nullable_to_non_nullable
as String?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
