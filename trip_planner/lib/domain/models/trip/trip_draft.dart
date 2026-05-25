import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_draft.freezed.dart';

@freezed
abstract class TripDraft with _$TripDraft {
  const factory TripDraft({
    @Default('') String destination,
    String? destinationPlaceId,
    double? budget,
    @Default('PLN') String currency,
    DateTime? startDate,
    DateTime? endDate,
  }) = _TripDraft;
}
