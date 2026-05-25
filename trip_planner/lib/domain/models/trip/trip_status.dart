enum TripStatus { upcoming, ongoing, past }

extension TripStatusX on TripStatus {
  static TripStatus fromDates({
    required DateTime startDate,
    required DateTime endDate,
    DateTime? now,
  }) {
    final today = DateTime(
      (now ?? DateTime.now()).year,
      (now ?? DateTime.now()).month,
      (now ?? DateTime.now()).day,
    );
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    if (today.isBefore(start)) return TripStatus.upcoming;
    if (today.isAfter(end)) return TripStatus.past;
    return TripStatus.ongoing;
  }
}
