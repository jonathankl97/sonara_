import 'package:flutter_test/flutter_test.dart';
import 'package:sonara/features/rooms/data/enums/room_enums.dart';
import 'package:sonara/features/rooms/data/models/opening_hours_model.dart';
import 'package:sonara/features/rooms/data/models/room_equipment_model.dart';
import 'package:sonara/features/rooms/data/models/room_model.dart';
import 'package:sonara/shared/enums/booking_mode.dart';

void main() {
  final fullJson = {
    'id': 'room-1',
    'providerId': 'provider-1',
    'name': 'Studio A',
    'description': 'Ein professioneller Aufnahmeraum mit Tageslicht.',
    'roomType': 'recordingStudio',
    'priceModel': 'hourly',
    'bookingMode': 'onRequest',
    'basePrice': '60.00',
    'sizeSqm': 45,
    'capacity': 4,
    'address': 'Musterstrasse 13',
    'city': 'Berlin',
    'zip': '10115',
    'state': 'Berlin',
    'country': 'Deutschland',
    'amenities': ['wifi', 'parking'],
    'equipment': [
      {'category': 'daw', 'name': 'Logic Pro'},
      {'category': 'microphone', 'name': 'Neumann U87'},
    ],
    'imageUrls': ['https://example.com/img1.jpg'],
    'openingHours': {
      'days': ['monday', 'tuesday', 'wednesday'],
      'openFrom': '09:00',
      'openTo': '22:00',
    },
    'isActive': true,
    'createdAt': '2024-01-15T10:00:00.000Z',
  };

  group('RoomModel.fromJson', () {
    test('parst ein vollstaendiges JSON korrekt', () {
      final room = RoomModel.fromJson(fullJson);

      expect(room.id, 'room-1');
      expect(room.providerId, 'provider-1');
      expect(room.name, 'Studio A');
      expect(
        room.description,
        'Ein professioneller Aufnahmeraum mit Tageslicht.',
      );
      expect(room.roomType, RoomType.recordingStudio);
      expect(room.priceModel, RoomPriceModel.hourly);
      expect(room.bookingMode, BookingMode.onRequest);
      expect(room.basePrice, 60.0);
      expect(room.sizeSqm, 45);
      expect(room.capacity, 4);
      expect(room.address, 'Musterstrasse 13');
      expect(room.city, 'Berlin');
      expect(room.zip, '10115');
      expect(room.state, 'Berlin');
      expect(room.country, 'Deutschland');
      expect(room.amenities, ['wifi', 'parking']);
      expect(room.equipment, hasLength(2));
      expect(room.imageUrls, hasLength(1));
      expect(room.openingHours, isNotNull);
      expect(room.isActive, true);
      expect(room.createdAt, isNotNull);
    });

    test('basePrice als String wird korrekt geparst', () {
      final room = RoomModel.fromJson(fullJson);

      expect(room.basePrice, 60.0);
      expect(room.basePrice, isA<double>());
    });

    test('basePrice als Zahl wird korrekt geparst', () {
      final json = {...fullJson, 'basePrice': 75};
      final room = RoomModel.fromJson(json);

      expect(room.basePrice, 75.0);
    });

    test('basePrice null faellt auf 0 zurueck', () {
      final json = {...fullJson, 'basePrice': null};
      final room = RoomModel.fromJson(json);

      expect(room.basePrice, 0.0);
    });

    test('setzt Defaults wenn optionale Felder fehlen', () {
      final minimalJson = {
        'name': 'Test Room',
        'description': 'Ein Testraum',
        'roomType': 'rehearsalRoom',
        'priceModel': 'hourly',
        'bookingMode': 'onRequest',
        'basePrice': 40,
        'address': 'Teststr. 1',
        'city': 'Hamburg',
        'zip': '20095',
        'state': 'Hamburg',
        'country': 'Deutschland',
      };
      final room = RoomModel.fromJson(minimalJson);

      expect(room.id, isNull);
      expect(room.providerId, isNull);
      expect(room.createdAt, isNull);
      expect(room.sizeSqm, isNull);
      expect(room.capacity, isNull);
      expect(room.amenities, isEmpty);
      expect(room.equipment, isEmpty);
      expect(room.imageUrls, isEmpty);
      expect(room.openingHours, isNull);
      expect(room.isActive, true);
    });

    test('unbekannter roomType faellt auf other zurueck', () {
      final json = {...fullJson, 'roomType': 'garage'};
      final room = RoomModel.fromJson(json);

      expect(room.roomType, RoomType.other);
    });
  });

  group('RoomModel.toCreateJson', () {
    test('erzeugt korrektes JSON fuer POST /rooms', () {
      final room = RoomModel(
        name: 'Studio A',
        description: 'Aufnahmeraum',
        roomType: RoomType.recordingStudio,
        priceModel: RoomPriceModel.hourly,
        bookingMode: BookingMode.onRequest,
        basePrice: 60,
        address: 'Musterstrasse 13',
        city: 'Berlin',
        zip: '10115',
        state: 'Berlin',
        country: 'Deutschland',
        amenities: ['wifi'],
        equipment: [
          const RoomEquipmentModel(
            category: RoomEquipmentCategory.daw,
            name: 'Logic Pro',
          ),
        ],
        openingHours: const OpeningHoursModel(
          days: ['monday'],
          openFrom: '09:00',
          openTo: '22:00',
        ),
      );

      final json = room.toCreateJson();

      expect(json['name'], 'Studio A');
      expect(json['roomType'], 'recordingStudio');
      expect(json['priceModel'], 'hourly');
      expect(json['bookingMode'], 'onRequest');
      expect(json['basePrice'], 60);
      expect(json['address'], 'Musterstrasse 13');
      expect(json['city'], 'Berlin');
      expect(json['amenities'], ['wifi']);
      expect(json['equipment'], hasLength(1));
      expect((json['equipment'] as List).first['category'], 'daw');
      expect(json['openingHours'], isNotNull);
      expect((json['openingHours'] as Map)['openFrom'], '09:00');
    });

    test('laesst id, providerId und createdAt weg', () {
      final room = RoomModel(
        id: 'room-1',
        providerId: 'provider-1',
        createdAt: DateTime.now(),
        name: 'Test',
        description: 'Test',
        roomType: RoomType.rehearsalRoom,
        priceModel: RoomPriceModel.hourly,
        bookingMode: BookingMode.onRequest,
        basePrice: 40,
        address: 'Test',
        city: 'Test',
        zip: '12345',
        state: 'Test',
        country: 'Test',
      );

      final json = room.toCreateJson();

      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('providerId'), isFalse);
      expect(json.containsKey('createdAt'), isFalse);
    });

    test('laesst optionale Felder weg wenn null', () {
      final room = RoomModel(
        name: 'Minimal',
        description: 'Minimal',
        roomType: RoomType.other,
        priceModel: RoomPriceModel.perDay,
        bookingMode: BookingMode.onRequest,
        basePrice: 200,
        address: 'A',
        city: 'B',
        zip: '00000',
        state: 'C',
        country: 'D',
      );

      final json = room.toCreateJson();

      expect(json.containsKey('sizeSqm'), isFalse);
      expect(json.containsKey('capacity'), isFalse);
      expect(json.containsKey('openingHours'), isFalse);
    });

    test('Enum-Werte werden als Strings serialisiert', () {
      final room = RoomModel(
        name: 'Test',
        description: 'Test',
        roomType: RoomType.djBooth,
        priceModel: RoomPriceModel.perDay,
        bookingMode: BookingMode.weeklyAvailability,
        basePrice: 300,
        address: 'A',
        city: 'B',
        zip: '00000',
        state: 'C',
        country: 'D',
      );

      final json = room.toCreateJson();

      expect(json['roomType'], 'djBooth');
      expect(json['priceModel'], 'perDay');
      expect(json['bookingMode'], 'weeklyAvailability');
    });
  });

  group('RoomEquipmentModel', () {
    test('fromJson parst korrekt mit Enum-Kategorie', () {
      final eq = RoomEquipmentModel.fromJson({
        'category': 'microphone',
        'name': 'Neumann U87',
      });

      expect(eq.category, RoomEquipmentCategory.microphone);
      expect(eq.name, 'Neumann U87');
    });

    test('fromJson faellt bei unbekannter Kategorie auf other zurueck', () {
      final eq = RoomEquipmentModel.fromJson({
        'category': 'laser',
        'name': 'Disco Laser 3000',
      });

      expect(eq.category, RoomEquipmentCategory.other);
    });

    test('toJson erzeugt korrektes JSON', () {
      const eq = RoomEquipmentModel(
        category: RoomEquipmentCategory.daw,
        name: 'Logic Pro',
      );

      final json = eq.toJson();

      expect(json['category'], 'daw');
      expect(json['name'], 'Logic Pro');
    });

    test('fromJson und toJson sind symmetrisch', () {
      final original = RoomEquipmentModel.fromJson({
        'category': 'djGear',
        'name': 'Pioneer CDJ-3000',
      });
      final json = original.toJson();
      final restored = RoomEquipmentModel.fromJson(json);

      expect(restored.category, original.category);
      expect(restored.name, original.name);
    });
  });

  group('OpeningHoursModel', () {
    test('fromJson parst korrekt', () {
      final oh = OpeningHoursModel.fromJson({
        'days': ['monday', 'wednesday', 'friday'],
        'openFrom': '10:00',
        'openTo': '20:00',
      });

      expect(oh.days, ['monday', 'wednesday', 'friday']);
      expect(oh.openFrom, '10:00');
      expect(oh.openTo, '20:00');
    });

    test('fromJson mit leerer days-Liste', () {
      final oh = OpeningHoursModel.fromJson({
        'days': null,
        'openFrom': '09:00',
        'openTo': '17:00',
      });

      expect(oh.days, isEmpty);
    });

    test('toJson erzeugt korrektes JSON', () {
      const oh = OpeningHoursModel(
        days: ['monday', 'tuesday'],
        openFrom: '09:00',
        openTo: '22:00',
      );

      final json = oh.toJson();

      expect(json['days'], ['monday', 'tuesday']);
      expect(json['openFrom'], '09:00');
      expect(json['openTo'], '22:00');
    });

    test('fromJson und toJson sind symmetrisch', () {
      final original = OpeningHoursModel.fromJson({
        'days': ['monday', 'friday'],
        'openFrom': '08:00',
        'openTo': '23:00',
      });
      final json = original.toJson();
      final restored = OpeningHoursModel.fromJson(json);

      expect(restored.days, original.days);
      expect(restored.openFrom, original.openFrom);
      expect(restored.openTo, original.openTo);
    });
  });
}
