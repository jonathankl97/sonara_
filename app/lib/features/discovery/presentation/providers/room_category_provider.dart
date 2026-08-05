import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/features/discovery/data/enums/room_category.dart';
import 'package:sonara/features/discovery/data/models/room_search_result.dart';
import 'package:sonara/features/discovery/data/repositories/discovery_repository.dart';

final roomListProvider =
    FutureProvider.family<List<RoomSearchResult>, RoomCategory>((
      ref,
      category,
    ) async {
      final repository = ref.watch(discoveryRepositoryProvider);

      switch (category) {
        case RoomCategory.popular:
          // Sortiert nach Rating (Backend-Default)
          final result = await repository.searchRooms();
          return result.data;

        case RoomCategory.sofortBuchbar:
          // Rooms mit weeklyAvailability BookingMode
          final result = await repository.searchRooms();
          // Client-seitig filtern bis Backend den Filter unterstuetzt
          return result.data
              .where((r) => r.bookingMode.value == 'weeklyAvailability')
              .toList();

        case RoomCategory.nearby:
          // TODO: User-Standort dynamisch ermitteln
          final result = await repository.searchRooms(city: 'Berlin');
          return result.data;
      }
    });
