enum ServiceType {
  recording('recording'),
  mixing('mixing'),
  mastering('mastering'),
  production('production'),
  songwriting('songwriting'),
  toplining('toplining'),
  vocals('vocals'),
  instrumentalist('instrumentalist'),
  arrangement('arrangement'),
  soundDesign('soundDesign'),
  other('other');

  final String value;
  const ServiceType(this.value);

  static ServiceType fromValue(String value) {
    return ServiceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ServiceType.other,
    );
  }
}

enum PriceModel {
  fixed('fixed'),
  hourly('hourly'),
  perTrack('perTrack'),
  inquiry('inquiry');

  final String value;
  const PriceModel(this.value);

  static PriceModel fromValue(String value) {
    return PriceModel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PriceModel.inquiry,
    );
  }
}

enum ServiceLocation {
  remote('remote'),
  onsite('onsite'),
  hybrid('hybrid');

  final String value;
  const ServiceLocation(this.value);

  static ServiceLocation fromValue(String value) {
    return ServiceLocation.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ServiceLocation.remote,
    );
  }
}


