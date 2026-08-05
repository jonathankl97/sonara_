enum RoomType {
  recordingStudio('recordingStudio'),
  rehearsalRoom('rehearsalRoom'),
  productionSuite('productionSuite'),
  podcastStudio('podcastStudio'),
  vocalBooth('vocalBooth'),
  djBooth('djBooth'),
  other('other');

  final String value;
  const RoomType(this.value);

  String get label {
    const labels = {
      'recordingStudio': 'Tonstudio',
      'rehearsalRoom': 'Proberaum',
      'productionSuite': 'Produktionsstudio',
      'podcastStudio': 'Podcast-Studio',
      'vocalBooth': 'Gesangskabine',
      'djBooth': 'DJ Booth',
      'other': 'Sonstiges',
    };
    return labels[value] ?? 'Sonstiges';
  }

  static RoomType fromValue(String value) {
    return RoomType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RoomType.other,
    );
  }
}

enum RoomPriceModel {
  hourly('hourly'),
  perDay('perDay');

  final String value;
  const RoomPriceModel(this.value);

  String get label {
    return value == 'hourly' ? 'Stundenpreis' : 'Tagespreis';
  }

  static RoomPriceModel fromValue(String value) {
    return RoomPriceModel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RoomPriceModel.hourly,
    );
  }
}

enum RoomEquipmentCategory {
  daw('daw'),
  microphone('microphone'),
  mixer('mixer'),
  audioInterface('audioInterface'),
  monitor('monitor'),
  headphones('headphones'),
  instrument('instrument'),
  djGear('djGear'),
  outboard('outboard'),
  other('other');

  final String value;
  const RoomEquipmentCategory(this.value);

  String get label {
    const labels = {
      'daw': 'DAW',
      'microphone': 'Mikrofon',
      'mixer': 'Mischpult',
      'audioInterface': 'Audio-Interface',
      'monitor': 'Monitor',
      'headphones': 'Kopfhörer',
      'instrument': 'Instrument',
      'djGear': 'DJ-Equipment',
      'outboard': 'Outboard',
      'other': 'Sonstiges',
    };
    return labels[value] ?? 'Sonstiges';
  }

  static RoomEquipmentCategory fromValue(String value) {
    return RoomEquipmentCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RoomEquipmentCategory.other,
    );
  }
}
