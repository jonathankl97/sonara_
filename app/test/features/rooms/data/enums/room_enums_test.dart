import 'package:flutter_test/flutter_test.dart';
import 'package:sonara/features/rooms/data/enums/room_enums.dart';
import 'package:sonara/shared/enums/booking_mode.dart';

void main() {
  group('RoomType', () {
    test('fromValue gibt korrekten Enum-Wert zurueck', () {
      expect(RoomType.fromValue('recordingStudio'), RoomType.recordingStudio);
      expect(RoomType.fromValue('rehearsalRoom'), RoomType.rehearsalRoom);
      expect(RoomType.fromValue('djBooth'), RoomType.djBooth);
    });

    test('fromValue faellt bei unbekanntem Wert auf other zurueck', () {
      expect(RoomType.fromValue('garage'), RoomType.other);
      expect(RoomType.fromValue(''), RoomType.other);
    });

    test('value gibt korrekten String zurueck', () {
      expect(RoomType.recordingStudio.value, 'recordingStudio');
      expect(RoomType.djBooth.value, 'djBooth');
      expect(RoomType.other.value, 'other');
    });
  });

  group('RoomPriceModel', () {
    test('fromValue gibt korrekten Enum-Wert zurueck', () {
      expect(RoomPriceModel.fromValue('hourly'), RoomPriceModel.hourly);
      expect(RoomPriceModel.fromValue('perDay'), RoomPriceModel.perDay);
    });

    test('fromValue faellt bei unbekanntem Wert auf hourly zurueck', () {
      expect(RoomPriceModel.fromValue('perMinute'), RoomPriceModel.hourly);
    });

    test('value gibt korrekten String zurueck', () {
      expect(RoomPriceModel.hourly.value, 'hourly');
      expect(RoomPriceModel.perDay.value, 'perDay');
    });
  });

  group('RoomEquipmentCategory', () {
    test('fromValue gibt korrekten Enum-Wert zurueck', () {
      expect(RoomEquipmentCategory.fromValue('daw'), RoomEquipmentCategory.daw);
      expect(
        RoomEquipmentCategory.fromValue('microphone'),
        RoomEquipmentCategory.microphone,
      );
      expect(
        RoomEquipmentCategory.fromValue('djGear'),
        RoomEquipmentCategory.djGear,
      );
      expect(
        RoomEquipmentCategory.fromValue('audioInterface'),
        RoomEquipmentCategory.audioInterface,
      );
    });

    test('fromValue faellt bei unbekanntem Wert auf other zurueck', () {
      expect(
        RoomEquipmentCategory.fromValue('laser'),
        RoomEquipmentCategory.other,
      );
    });

    test('value gibt korrekten String zurueck', () {
      expect(RoomEquipmentCategory.daw.value, 'daw');
      expect(RoomEquipmentCategory.djGear.value, 'djGear');
      expect(RoomEquipmentCategory.outboard.value, 'outboard');
    });
  });

  group('RoomBookingMode', () {
    test('fromValue gibt korrekten Enum-Wert zurueck', () {
      expect(BookingMode.fromValue('onRequest'), BookingMode.onRequest);
      expect(
        BookingMode.fromValue('weeklyAvailability'),
        BookingMode.weeklyAvailability,
      );
    });

    test('fromValue faellt bei unbekanntem Wert auf onRequest zurueck', () {
      expect(BookingMode.fromValue('instant'), BookingMode.onRequest);
    });

    test('value gibt korrekten String zurueck', () {
      expect(BookingMode.onRequest.value, 'onRequest');
      expect(BookingMode.weeklyAvailability.value, 'weeklyAvailability');
    });
  });
}
