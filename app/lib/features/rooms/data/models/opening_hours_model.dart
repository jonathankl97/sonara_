class OpeningHoursModel {
  final List<String> days;
  final String openFrom;
  final String openTo;

  const OpeningHoursModel({
    required this.days,
    required this.openFrom,
    required this.openTo,
  });

  factory OpeningHoursModel.fromJson(Map<String, dynamic> json) {
    return OpeningHoursModel(
      days: (json['days'] as List<dynamic>?)
              ?.map((d) => d as String)
              .toList() ??
          [],
      openFrom: json['openFrom'] as String,
      openTo: json['openTo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'days': days, 'openFrom': openFrom, 'openTo': openTo};
  }
}