import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/features/discovery/data/models/room_search_result.dart';
import 'package:sonara/features/discovery/data/repositories/discovery_repository.dart';
import 'room_filter_state.dart';

class RoomDiscoveryState {
  final List<RoomSearchResult> rooms;
  final int total;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const RoomDiscoveryState({
    this.rooms = const [],
    this.total = 0,
    this.currentPage = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  RoomDiscoveryState copyWith({
    List<RoomSearchResult>? rooms,
    int? total,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return RoomDiscoveryState(
      rooms: rooms ?? this.rooms,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class RoomDiscoveryNotifier extends AsyncNotifier<RoomDiscoveryState> {
  late DiscoveryRepository _repository;

  @override
  Future<RoomDiscoveryState> build() async {
    _repository = ref.read(discoveryRepositoryProvider);

    final filters = ref.watch(roomFilterProvider);

    final result = await _repository.searchRooms(
      roomType: filters.roomType,
      city: filters.city,
      minPrice: filters.minPrice,
      maxPrice: filters.maxPrice,
      capacity: filters.capacity,
      amenities: filters.amenitiesParam,
    );

    return RoomDiscoveryState(
      rooms: result.data,
      total: result.total,
      currentPage: result.page,
      hasMore: result.hasMore,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final filters = ref.read(roomFilterProvider);
    final nextPage = current.currentPage + 1;

    final result = await _repository.searchRooms(
      roomType: filters.roomType,
      city: filters.city,
      minPrice: filters.minPrice,
      maxPrice: filters.maxPrice,
      capacity: filters.capacity,
      amenities: filters.amenitiesParam,
      page: nextPage,
    );

    state = AsyncData(RoomDiscoveryState(
      rooms: [...current.rooms, ...result.data],
      total: result.total,
      currentPage: nextPage,
      hasMore: result.hasMore,
    ));
  }
}

final roomDiscoveryProvider =
    AsyncNotifierProvider<RoomDiscoveryNotifier, RoomDiscoveryState>(
  RoomDiscoveryNotifier.new,
);
