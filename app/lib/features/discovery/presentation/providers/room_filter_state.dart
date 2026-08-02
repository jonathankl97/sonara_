import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomFilterState {
  final String? roomType;
  final String? city;
  final double? minPrice;
  final double? maxPrice;
  final int? capacity;
  final List<String> amenities;

  const RoomFilterState({
    this.roomType,
    this.city,
    this.minPrice,
    this.maxPrice,
    this.capacity,
    this.amenities = const [],
  });

  RoomFilterState copyWith({
    String? roomType,
    String? city,
    double? minPrice,
    double? maxPrice,
    int? capacity,
    List<String>? amenities,
  }) {
    return RoomFilterState(
      roomType: roomType ?? this.roomType,
      city: city ?? this.city,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      capacity: capacity ?? this.capacity,
      amenities: amenities ?? this.amenities,
    );
  }

  String? get amenitiesParam => amenities.isEmpty ? null : amenities.join(',');

  bool get hasActiveFilters =>
      roomType != null ||
      city != null ||
      minPrice != null ||
      maxPrice != null ||
      capacity != null ||
      amenities.isNotEmpty;
}

class RoomFilterNotifier extends Notifier<RoomFilterState> {
  @override
  RoomFilterState build() => const RoomFilterState();

  void update(RoomFilterState newState) {
    state = newState;
  }

  void reset() {
    state = const RoomFilterState();
  }
}

final roomFilterProvider =
    NotifierProvider<RoomFilterNotifier, RoomFilterState>(
      RoomFilterNotifier.new,
    );
