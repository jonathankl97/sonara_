import 'package:flutter_test/flutter_test.dart';
import 'package:sonara/features/services/data/enums/service_enums.dart';
import 'package:sonara/features/services/data/models/service_model.dart';
import 'package:sonara/shared/enums/booking_mode.dart';

void main() {
  // Vollstaendiges JSON wie es vom Backend kommt.
  final fullJson = {
    'id': 'service-1',
    'providerId': 'provider-1',
    'title': 'Professionelles Mixing',
    'description': 'Dein Track, perfekt gemischt.',
    'serviceType': 'mixing',
    'location': 'remote',
    'priceModel': 'fixed',
    'bookingMode': 'onRequest',
    'audioLength': 5,
    'basePrice': '150.00',
    'revisionsOffered': true,
    'revisionCount': 2,
    'allowCustomRequests': true,
    'genres': ['hiphop', 'pop'],
    'coreServices': ['Leveling', 'EQ & Kompression'],
    'addOns': [
      {'title': 'Express', 'description': '48h Lieferung', 'price': 50},
    ],
    'createdAt': '2024-01-15T10:00:00.000Z',
  };

  group('ServiceModel.fromJson', () {
    test('parst ein vollstaendiges JSON korrekt', () {
      final service = ServiceModel.fromJson(fullJson);

      expect(service.id, 'service-1');
      expect(service.providerId, 'provider-1');
      expect(service.title, 'Professionelles Mixing');
      expect(service.description, 'Dein Track, perfekt gemischt.');
      expect(service.serviceType, ServiceType.mixing);
      expect(service.location, ServiceLocation.remote);
      expect(service.priceModel, PriceModel.fixed);
      expect(service.bookingMode, BookingMode.onRequest);
      expect(service.audioLength, 5);
      expect(service.basePrice, 150.0);
      expect(service.revisionsOffered, true);
      expect(service.revisionCount, 2);
      expect(service.allowCustomRequests, true);
      expect(service.genres, ['hiphop', 'pop']);
      expect(service.coreServices, ['Leveling', 'EQ & Kompression']);
      expect(service.addOns, hasLength(1));
      expect(service.addOns.first.title, 'Express');
      expect(service.createdAt, isNotNull);
    });

    test('basePrice als String wird korrekt geparst', () {
      final service = ServiceModel.fromJson(fullJson);

      expect(service.basePrice, 150.0);
      expect(service.basePrice, isA<double>());
    });

    test('basePrice als Zahl wird korrekt geparst', () {
      final json = {...fullJson, 'basePrice': 200};
      final service = ServiceModel.fromJson(json);

      expect(service.basePrice, 200.0);
    });

    test('basePrice null bei inquiry bleibt null', () {
      final json = {...fullJson, 'priceModel': 'inquiry', 'basePrice': null};
      final service = ServiceModel.fromJson(json);

      expect(service.basePrice, isNull);
      expect(service.priceModel, PriceModel.inquiry);
    });

    test('setzt Defaults wenn optionale Felder fehlen', () {
      final minimalJson = {
        'title': 'Test',
        'description': 'Beschreibung',
        'serviceType': 'mixing',
        'location': 'remote',
        'priceModel': 'fixed',
        'bookingMode': 'onRequest',
      };
      final service = ServiceModel.fromJson(minimalJson);

      expect(service.id, isNull);
      expect(service.providerId, isNull);
      expect(service.createdAt, isNull);
      expect(service.audioLength, isNull);
      expect(service.basePrice, isNull);
      expect(service.revisionsOffered, false);
      expect(service.revisionCount, isNull);
      expect(service.allowCustomRequests, false);
      expect(service.genres, isEmpty);
      expect(service.coreServices, isEmpty);
      expect(service.addOns, isEmpty);
    });

    test('unbekannter serviceType faellt auf other zurueck', () {
      final json = {...fullJson, 'serviceType': 'beatboxing'};
      final service = ServiceModel.fromJson(json);

      expect(service.serviceType, ServiceType.other);
    });
  });

  group('ServiceModel.toCreateJson', () {
    test('erzeugt korrektes JSON fuer POST /services', () {
      final service = ServiceModel(
        title: 'Mixing',
        description: 'Pro mix',
        serviceType: ServiceType.mixing,
        location: ServiceLocation.remote,
        priceModel: PriceModel.fixed,
        bookingMode: BookingMode.onRequest,
        basePrice: 150,
        genres: ['hiphop'],
        coreServices: ['EQ'],
        addOns: [
          const ServiceAddOnModel(
            title: 'Express',
            description: '48h',
            price: 50,
          ),
        ],
      );

      final json = service.toCreateJson();

      expect(json['title'], 'Mixing');
      expect(json['serviceType'], 'mixing');
      expect(json['location'], 'remote');
      expect(json['priceModel'], 'fixed');
      expect(json['bookingMode'], 'onRequest');
      expect(json['basePrice'], 150);
      expect(json['genres'], ['hiphop']);
      expect(json['coreServices'], ['EQ']);
      expect(json['addOns'], hasLength(1));
      expect((json['addOns'] as List).first['title'], 'Express');
    });

    test('laesst id, providerId und createdAt weg', () {
      final service = ServiceModel(
        id: 'service-1',
        providerId: 'provider-1',
        createdAt: DateTime.now(),
        title: 'Test',
        description: 'Test',
        serviceType: ServiceType.mixing,
        location: ServiceLocation.remote,
        priceModel: PriceModel.fixed,
        bookingMode: BookingMode.onRequest,
      );

      final json = service.toCreateJson();

      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('providerId'), isFalse);
      expect(json.containsKey('createdAt'), isFalse);
    });

    test('laesst basePrice weg wenn null (inquiry)', () {
      final service = ServiceModel(
        title: 'Beratung',
        description: 'Auf Anfrage',
        serviceType: ServiceType.other,
        location: ServiceLocation.remote,
        priceModel: PriceModel.inquiry,
        bookingMode: BookingMode.onRequest,
      );

      final json = service.toCreateJson();

      expect(json.containsKey('basePrice'), isFalse);
    });

    test('Enum-Werte werden als Strings serialisiert', () {
      final service = ServiceModel(
        title: 'Test',
        description: 'Test',
        serviceType: ServiceType.soundDesign,
        location: ServiceLocation.hybrid,
        priceModel: PriceModel.perTrack,
        bookingMode: BookingMode.weeklyAvailability,
      );

      final json = service.toCreateJson();

      expect(json['serviceType'], 'soundDesign');
      expect(json['location'], 'hybrid');
      expect(json['priceModel'], 'perTrack');
      expect(json['bookingMode'], 'weeklyAvailability');
    });
  });

  group('ServiceAddOnModel', () {
    test('fromJson parst korrekt', () {
      final addon = ServiceAddOnModel.fromJson({
        'title': 'Express',
        'description': '48h Lieferung',
        'price': 50,
      });

      expect(addon.title, 'Express');
      expect(addon.description, '48h Lieferung');
      expect(addon.price, 50.0);
    });

    test('fromJson parst price als String', () {
      final addon = ServiceAddOnModel.fromJson({
        'title': 'Express',
        'description': '48h',
        'price': '49.99',
      });

      expect(addon.price, 49.99);
    });

    test('toJson erzeugt korrektes JSON', () {
      const addon = ServiceAddOnModel(
        title: 'Express',
        description: '48h Lieferung',
        price: 50,
      );

      final json = addon.toJson();

      expect(json['title'], 'Express');
      expect(json['description'], '48h Lieferung');
      expect(json['price'], 50);
    });
  });
}
