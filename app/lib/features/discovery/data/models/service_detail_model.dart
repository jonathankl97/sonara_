import 'package:sonara/shared/utils/parse_price.dart';

class ServiceDetailModel {
  final String id;
  final String title;
  final String? description;
  final String serviceType;
  final double? basePrice;
  final String priceModel;
  final String location;
  final String bookingMode;
  final List<String> genres;
  final bool revisionsOffered;
  final int? revisionCount;

  const ServiceDetailModel({
    required this.id,
    required this.title,
    this.description,
    required this.serviceType,
    this.basePrice,
    required this.priceModel,
    required this.location,
    required this.bookingMode,
    this.genres = const [],
    this.revisionsOffered = false,
    this.revisionCount,
  });

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      serviceType: json['serviceType'] as String,
      basePrice: parsePrice(json['basePrice']),
      priceModel: json['priceModel'] as String,
      location: json['location'] as String,
      bookingMode: json['bookingMode'] as String,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((g) => g as String)
              .toList() ??
          [],
      revisionsOffered: json['revisionsOffered'] as bool? ?? false,
      revisionCount: json['revisionCount'] as int?,
    );
  }

  String get priceLabel {
    if (basePrice == null) return 'Auf Anfrage';
    final suffix = switch (priceModel) {
      'hourly' => '/Stunde',
      'perTrack' => '/Track',
      _ => '',
    };
    return '${basePrice!.toInt()}€$suffix';
  }

  String get locationLabel {
    return switch (location) {
      'remote' => 'Remote',
      'onsite' => 'Vor Ort',
      'hybrid' => 'Hybrid',
      _ => location,
    };
  }
}
