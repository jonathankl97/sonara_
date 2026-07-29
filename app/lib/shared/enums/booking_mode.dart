enum BookingMode {
  onRequest('onRequest'),
  weeklyAvailability('weeklyAvailability');

  final String value;
  const BookingMode(this.value);

  static BookingMode fromValue(String value) {
    return BookingMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BookingMode.onRequest,
    );
  }
}