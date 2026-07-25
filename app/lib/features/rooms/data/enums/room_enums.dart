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

// Dupliziert aus service_enums.dart — spaeter in eine geteilte
// Datei (z.B. shared/enums/booking_mode.dart) auslagern.
enum RoomBookingMode {
  onRequest('onRequest'),
  weeklyAvailability('weeklyAvailability');

  final String value;
  const RoomBookingMode(this.value);

  static RoomBookingMode fromValue(String value) {
    return RoomBookingMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RoomBookingMode.onRequest,
    );
  }
}