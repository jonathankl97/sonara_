import 'package:sonara/features/rooms/data/enums/room_enums.dart';
import 'package:sonara/shared/enums/booking_mode.dart';
import 'package:sonara/features/rooms/data/models/room_equipment_model.dart';
import 'package:sonara/features/rooms/data/models/opening_hours_model.dart';

class ProviderDetailSummary {
  final String id;
  final String? displayName;
  final String? profileImageUrl;
  final String? bio;
  final double ratingAverage;
  final int ratingCount;

  const ProviderDetailSummary({
    required this.id,
    this.displayName,
    this.profileImageUrl,
    this.bio,
    this.ratingAverage = 0,
    this.ratingCount = 0,
  });

  factory ProviderDetailSummary.fromJson(Map<String, dynamic> json) {
    return ProviderDetailSummary(
      id: json['id'] as String,
      displayName: json['displayName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0,
      ratingCount: json['ratingCount'] as int? ?? 0,
    );
  }
}

class RoomDetailModel {
  final String id;
  final String name;
  final String description;
  final RoomType roomType;
  final String city;
  final String address;
  final String zip;
  final String state;
  final String country;
  final double basePrice;
  final RoomPriceModel priceModel;
  final BookingMode bookingMode;
  final int? sizeSqm;
  final int? capacity;
  final List<String> amenities;
  final List<RoomEquipmentModel> equipment;
  final List<String> imageUrls;
  final OpeningHoursModel? openingHours;
  final DateTime? createdAt;
  final double ratingAverage;
  final int ratingCount;
  final ProviderDetailSummary provider;

  const RoomDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.roomType,
    required this.city,
    required this.address,
    required this.zip,
    required this.state,
    required this.country,
    required this.basePrice,
    required this.priceModel,
    required this.bookingMode,
    this.sizeSqm,
    this.capacity,
    this.amenities = const [],
    this.equipment = const [],
    this.imageUrls = const [],
    this.openingHours,
    this.createdAt,
    required this.provider,
    required this.ratingAverage,
    required this.ratingCount,
  });

  factory RoomDetailModel.fromJson(Map<String, dynamic> json) {
    return RoomDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      roomType: RoomType.fromValue(json['roomType'] as String),
      city: json['city'] as String,
      address: json['address'] as String,
      zip: json['zip'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      basePrice: _parsePrice(json['basePrice']) ?? 0,
      priceModel: RoomPriceModel.fromValue(json['priceModel'] as String),
      bookingMode: BookingMode.fromValue(json['bookingMode'] as String),
      sizeSqm: json['sizeSqm'] as int?,
      capacity: json['capacity'] as int?,
      amenities:
          (json['amenities'] as List<dynamic>?)
              ?.map((a) => a as String)
              .toList() ??
          [],
      equipment:
          (json['equipment'] as List<dynamic>?)
              ?.map(
                (e) => RoomEquipmentModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((u) => u as String)
              .toList() ??
          [],
      openingHours: json['openingHours'] != null
          ? OpeningHoursModel.fromJson(
              json['openingHours'] as Map<String, dynamic>,
            )
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      provider: ProviderDetailSummary.fromJson(
        json['provider'] as Map<String, dynamic>,
      ),
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0,
      ratingCount: json['ratingCount'] as int? ?? 0,
    );
  }

  String get fullAddress => '$address, $zip $city, $state, $country';

  String get priceLabel {
    final suffix = priceModel == RoomPriceModel.hourly
        ? 'pro Stunde'
        : 'pro Tag';
    return '${basePrice.toInt()}€ $suffix';
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

  String get firstImageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';
}

double? _parsePrice(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
