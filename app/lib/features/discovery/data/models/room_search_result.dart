import 'package:sonara/features/rooms/data/enums/room_enums.dart';
import 'package:sonara/shared/enums/booking_mode.dart';

class ProviderSummary {
  final String id;
  final String? displayName;
  final String? profileImageUrl;

  const ProviderSummary({
    required this.id,
    this.displayName,
    this.profileImageUrl,
  });

  factory ProviderSummary.fromJson(Map<String, dynamic> json) {
    return ProviderSummary(
      id: json['id'] as String,
      displayName: json['displayName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}

class RoomSearchResult {
  final String id;
  final String name;
  final String description;
  final RoomType roomType;
  final String city;
  final String address;
  final double basePrice;
  final RoomPriceModel priceModel;
  final BookingMode bookingMode;
  final int? capacity;
  final List<String> amenities;
  final List<String> imageUrls;
  final ProviderSummary provider;

  const RoomSearchResult({
    required this.id,
    required this.name,
    required this.description,
    required this.roomType,
    required this.city,
    required this.address,
    required this.basePrice,
    required this.priceModel,
    required this.bookingMode,
    this.capacity,
    this.amenities = const [],
    this.imageUrls = const [],
    required this.provider,
  });

  factory RoomSearchResult.fromJson(Map<String, dynamic> json) {
    return RoomSearchResult(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      roomType: RoomType.fromValue(json['roomType'] as String),
      city: json['city'] as String,
      address: json['address'] as String,
      basePrice: _parsePrice(json['basePrice']) ?? 0,
      priceModel: RoomPriceModel.fromValue(json['priceModel'] as String),
      bookingMode: BookingMode.fromValue(json['bookingMode'] as String),
      capacity: json['capacity'] as int?,
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((a) => a as String)
              .toList() ??
          [],
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((u) => u as String)
              .toList() ??
          [],
      provider: ProviderSummary.fromJson(
        json['provider'] as Map<String, dynamic>,
      ),
    );
  }

  String get firstImageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  String get priceLabel {
    final suffix = priceModel == RoomPriceModel.hourly ? 'pro Stunde' : 'pro Tag';
    return 'ab ${basePrice.toInt()}€ $suffix';
  }

  String get roomTypeLabel {
    const labels = {
      RoomType.recordingStudio: 'Recording Studio',
      RoomType.rehearsalRoom: 'Proberaum',
      RoomType.productionSuite: 'Produktionsraum',
      RoomType.podcastStudio: 'Podcast Studio',
      RoomType.vocalBooth: 'Vocal Booth',
      RoomType.djBooth: 'DJ Booth',
      RoomType.other: 'Sonstiges',
    };
    return labels[roomType] ?? 'Raum';
  }
}

double? _parsePrice(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
