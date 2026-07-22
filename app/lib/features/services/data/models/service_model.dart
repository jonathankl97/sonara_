import 'package:sonara/shared/enums/service_enums.dart';

class ServiceAddOnModel {
  final String title;
  final String description;
  final double price;

  const ServiceAddOnModel({
    required this.title,
    required this.description,
    required this.price,
  });

  factory ServiceAddOnModel.fromJson(Map<String, dynamic> json) {
    return ServiceAddOnModel(
      title: json['title'] as String,
      description: json['description'] as String,
      price: _parsePrice(json['price']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'price': price};
  }
}

class ServiceModel {
  // Beim Erstellen noch nicht vorhanden -> nullable.
  final String? id;
  final String? providerId;
  final DateTime? createdAt;

  final String title;
  final String description;

  final ServiceType serviceType;
  final ServiceLocation location;
  final PriceModel priceModel;
  final BookingMode bookingMode;

  final int? audioLength;

  // numeric kommt als String ueber die API; null bei priceModel = inquiry.
  final double? basePrice;

  final bool revisionsOffered;
  final int? revisionCount;
  final bool allowCustomRequests;

  final List<String> genres;
  final List<String> coreServices;
  final List<ServiceAddOnModel> addOns;

  const ServiceModel({
    this.id,
    this.providerId,
    this.createdAt,
    required this.title,
    required this.description,
    required this.serviceType,
    required this.location,
    required this.priceModel,
    required this.bookingMode,
    this.audioLength,
    this.basePrice,
    this.revisionsOffered = false,
    this.revisionCount,
    this.allowCustomRequests = false,
    this.genres = const [],
    this.coreServices = const [],
    this.addOns = const [],
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String?,
      providerId: json['providerId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,

      title: json['title'] as String,
      description: json['description'] as String,

      serviceType: ServiceType.fromValue(json['serviceType'] as String),
      location: ServiceLocation.fromValue(json['location'] as String),
      priceModel: PriceModel.fromValue(json['priceModel'] as String),
      bookingMode: BookingMode.fromValue(json['bookingMode'] as String),

      audioLength: json['audioLength'] as int?,

      basePrice: _parsePrice(json['basePrice']),

      revisionsOffered: json['revisionsOffered'] as bool? ?? false,
      revisionCount: json['revisionCount'] as int?,
      allowCustomRequests: json['allowCustomRequests'] as bool? ?? false,

      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((g) => g as String)
              .toList() ??
          [],

      coreServices:
          (json['coreServices'] as List<dynamic>?)
              ?.map((c) => c as String)
              .toList() ??
          [],

      addOns:
          (json['addOns'] as List<dynamic>?)
              ?.map(
                (a) => ServiceAddOnModel.fromJson(a as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  // Payload fuer POST /services. Laesst id/providerId/createdAt weg
  // (setzt das Backend); Enums werden zu ihren String-Werten (.value).
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'serviceType': serviceType.value,
      'location': location.value,
      'priceModel': priceModel.value,
      'bookingMode': bookingMode.value,
      if (audioLength != null) 'audioLength': audioLength,
      if (basePrice != null) 'basePrice': basePrice,
      'revisionsOffered': revisionsOffered,
      if (revisionCount != null) 'revisionCount': revisionCount,
      'allowCustomRequests': allowCustomRequests,
      'genres': genres,
      'coreServices': coreServices,
      'addOns': addOns.map((a) => a.toJson()).toList(),
    };
  }
}

// numeric kann als String ("150.00") oder als Zahl kommen; null bleibt null.
double? _parsePrice(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
