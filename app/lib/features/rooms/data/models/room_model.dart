import 'package:sonara/features/rooms/data/enums/room_enums.dart';
import 'package:sonara/features/rooms/data/models/opening_hours_model.dart';
import 'package:sonara/features/rooms/data/models/room_equipment_model.dart';

class RoomModel {
  // Beim Erstellen noch nicht vorhanden -> nullable.
  final String? id;
  final String? providerId;
  final DateTime? createdAt;

  final String name;
  final String description;

  final RoomType roomType;
  final RoomPriceModel priceModel;
  final RoomBookingMode bookingMode;

  // Immer Pflicht (kein inquiry bei Rooms).
  final double basePrice;

  final int? sizeSqm;
  final int? capacity;

  // Standort — alle Pflicht.
  final String address;
  final String city;
  final String zip;
  final String state;
  final String country;

  final List<String> amenities;
  final List<RoomEquipmentModel> equipment;
  final List<String> imageUrls;
  final OpeningHoursModel? openingHours;

  final bool isActive;

  const RoomModel({
    this.id,
    this.providerId,
    this.createdAt,
    required this.name,
    required this.description,
    required this.roomType,
    required this.priceModel,
    required this.bookingMode,
    required this.basePrice,
    this.sizeSqm,
    this.capacity,
    required this.address,
    required this.city,
    required this.zip,
    required this.state,
    required this.country,
    this.amenities = const [],
    this.equipment = const [],
    this.imageUrls = const [],
    this.openingHours,
    this.isActive = true,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String?,
      providerId: json['providerId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,

      name: json['name'] as String,
      description: json['description'] as String,

      roomType: RoomType.fromValue(json['roomType'] as String),
      priceModel: RoomPriceModel.fromValue(json['priceModel'] as String),
      bookingMode: RoomBookingMode.fromValue(json['bookingMode'] as String),

      basePrice: _parsePrice(json['basePrice']) ?? 0,

      sizeSqm: json['sizeSqm'] as int?,
      capacity: json['capacity'] as int?,

      address: json['address'] as String,
      city: json['city'] as String,
      zip: json['zip'] as String,
      state: json['state'] as String,
      country: json['country'] as String,

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

      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'description': description,
      'roomType': roomType.value,
      'priceModel': priceModel.value,
      'bookingMode': bookingMode.value,
      'basePrice': basePrice,
      if (sizeSqm != null) 'sizeSqm': sizeSqm,
      if (capacity != null) 'capacity': capacity,
      'address': address,
      'city': city,
      'zip': zip,
      'state': state,
      'country': country,
      'amenities': amenities,
      'equipment': equipment.map((e) => e.toJson()).toList(),
      'imageUrls': imageUrls,
      if (openingHours != null) 'openingHours': openingHours!.toJson(),
    };
  }
}

// numeric kann als String oder Zahl kommen; null bleibt null.
double? _parsePrice(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
