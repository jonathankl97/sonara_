import 'package:sonara/features/services/data/enums/service_enums.dart';
import 'package:sonara/shared/enums/booking_mode.dart';

class ServiceSummary {
  final String id;
  final String title;
  final ServiceType serviceType;
  final double? basePrice;
  final PriceModel priceModel;
  final ServiceLocation location;
  final BookingMode bookingMode;
  final List<String> genres;

  const ServiceSummary({
    required this.id,
    required this.title,
    required this.serviceType,
    this.basePrice,
    required this.priceModel,
    required this.location,
    required this.bookingMode,
    this.genres = const [],
  });

  factory ServiceSummary.fromJson(Map<String, dynamic> json) {
    return ServiceSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      serviceType: ServiceType.fromValue(json['serviceType'] as String),
      basePrice: _parsePrice(json['basePrice']),
      priceModel: PriceModel.fromValue(json['priceModel'] as String),
      location: ServiceLocation.fromValue(json['location'] as String),
      bookingMode: BookingMode.fromValue(json['bookingMode'] as String),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((g) => g as String)
              .toList() ??
          [],
    );
  }
}

class ProviderSearchResult {
  final String id;
  final String? displayName;
  final String? city;
  final String? profileImageUrl;
  final String? bio;
  final double ratingAverage;
  final int ratingCount;
  final List<ServiceSummary> services;

  const ProviderSearchResult({
    required this.id,
    this.displayName,
    this.city,
    this.profileImageUrl,
    this.bio,
    this.ratingAverage = 0,
    this.ratingCount = 0,
    this.services = const [],
  });

  factory ProviderSearchResult.fromJson(Map<String, dynamic> json) {
    return ProviderSearchResult(
      id: json['id'] as String,
      displayName: json['displayName'] as String?,
      city: json['city'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0,
      ratingCount: json['ratingCount'] as int? ?? 0,
      services: (json['services'] as List<dynamic>?)
              ?.map((s) => ServiceSummary.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get serviceTypesLabel =>
      services.map((s) => s.serviceType.value).toSet().join(', ');

  bool get hasSofortBuchbar =>
      services.any((s) => s.bookingMode == BookingMode.weeklyAvailability);
}

double? _parsePrice(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
