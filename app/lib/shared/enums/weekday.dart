enum Weekday {
  monday('monday', 'Mo'),
  tuesday('tuesday', 'Di'),
  wednesday('wednesday', 'Mi'),
  thursday('thursday', 'Do'),
  friday('friday', 'Fr'),
  saturday('saturday', 'Sa'),
  sunday('sunday', 'So');

  final String value;
  final String label;
  const Weekday(this.value, this.label);

  static Weekday fromValue(String value) {
    return Weekday.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Weekday.monday,
    );
  }
}
