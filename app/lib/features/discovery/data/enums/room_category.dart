enum RoomCategory {
  popular('popular', 'Beliebte Studios'),
  sofortBuchbar('weekly-availability', 'Sofort buchbar'),
  nearby('nearby', 'Studios in deiner Nähe');

  final String value;
  final String label;
  const RoomCategory(this.value, this.label);

  static RoomCategory fromValue(String value) {
    return RoomCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RoomCategory.popular,
    );
  }
}
