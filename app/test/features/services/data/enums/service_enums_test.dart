import 'package:flutter_test/flutter_test.dart';
import 'package:sonara/features/services/data/enums/service_enums.dart';

void main() {
  group('ServiceType', () {
    test('fromValue gibt korrekten Enum-Wert zurueck', () {
      expect(ServiceType.fromValue('mixing'), ServiceType.mixing);
      expect(ServiceType.fromValue('recording'), ServiceType.recording);
      expect(ServiceType.fromValue('soundDesign'), ServiceType.soundDesign);
    });

    test('fromValue faellt bei unbekanntem Wert auf other zurueck', () {
      expect(ServiceType.fromValue('beatboxing'), ServiceType.other);
      expect(ServiceType.fromValue(''), ServiceType.other);
    });

    test('value gibt korrekten String zurueck', () {
      expect(ServiceType.mixing.value, 'mixing');
      expect(ServiceType.soundDesign.value, 'soundDesign');
      expect(ServiceType.other.value, 'other');
    });
  });

  group('PriceModel', () {
    test('fromValue gibt korrekten Enum-Wert zurueck', () {
      expect(PriceModel.fromValue('fixed'), PriceModel.fixed);
      expect(PriceModel.fromValue('hourly'), PriceModel.hourly);
      expect(PriceModel.fromValue('perTrack'), PriceModel.perTrack);
      expect(PriceModel.fromValue('inquiry'), PriceModel.inquiry);
    });

    test('fromValue faellt bei unbekanntem Wert auf inquiry zurueck', () {
      expect(PriceModel.fromValue('unknown'), PriceModel.inquiry);
    });

    test('value gibt korrekten String zurueck', () {
      expect(PriceModel.fixed.value, 'fixed');
      expect(PriceModel.perTrack.value, 'perTrack');
    });
  });

  group('ServiceLocation', () {
    test('fromValue gibt korrekten Enum-Wert zurueck', () {
      expect(ServiceLocation.fromValue('remote'), ServiceLocation.remote);
      expect(ServiceLocation.fromValue('onsite'), ServiceLocation.onsite);
      expect(ServiceLocation.fromValue('hybrid'), ServiceLocation.hybrid);
    });

    test('fromValue faellt bei unbekanntem Wert auf remote zurueck', () {
      expect(ServiceLocation.fromValue('mars'), ServiceLocation.remote);
    });
  });

  group('BookingMode', () {
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
  });
}
