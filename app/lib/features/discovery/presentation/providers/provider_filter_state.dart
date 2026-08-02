import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderFilterState {
  final String? serviceType;
  final List<String> genres;
  final String? location;
  final double? minPrice;
  final double? maxPrice;
  final String? city;
  final bool remoteOnly;

  const ProviderFilterState({
    this.serviceType,
    this.genres = const [],
    this.location,
    this.minPrice,
    this.maxPrice,
    this.city,
    this.remoteOnly = false,
  });

  ProviderFilterState copyWith({
    String? serviceType,
    List<String>? genres,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? city,
    bool? remoteOnly,
  }) {
    return ProviderFilterState(
      serviceType: serviceType ?? this.serviceType,
      genres: genres ?? this.genres,
      location: location ?? this.location,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      city: city ?? this.city,
      remoteOnly: remoteOnly ?? this.remoteOnly,
    );
  }

  String? get genresParam => genres.isEmpty ? null : genres.join(',');

  bool get hasActiveFilters =>
      serviceType != null ||
      genres.isNotEmpty ||
      location != null ||
      minPrice != null ||
      maxPrice != null ||
      city != null ||
      remoteOnly;
}

class ProviderFilterNotifier extends Notifier<ProviderFilterState> {
  @override
  ProviderFilterState build() => const ProviderFilterState();

  void update(ProviderFilterState newState) {
    state = newState;
  }

  void reset() {
    state = const ProviderFilterState();
  }
}

final providerFilterProvider =
    NotifierProvider<ProviderFilterNotifier, ProviderFilterState>(
      ProviderFilterNotifier.new,
    );
