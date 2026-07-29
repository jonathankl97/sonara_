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

  static RoomType fromValue(String value) {
    return RoomType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RoomType.other,
    );
  }
}

const roomTypeLabels = {
  RoomType.recordingStudio: 'Tonstudio',
  RoomType.rehearsalRoom: 'Proberaum',
  RoomType.productionSuite: 'Produktionsstudio',
  RoomType.vocalBooth: 'Gesangskabine',
  RoomType.podcastStudio: 'Podcast-Studio',
};

enum RoomPriceModel {
  hourly('hourly'),
  perDay('perDay');

  final String value;
  const RoomPriceModel(this.value);

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

  static RoomEquipmentCategory fromValue(String value) {
    return RoomEquipmentCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RoomEquipmentCategory.other,
    );
  }
}


