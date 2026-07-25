import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/features/rooms/data/models/room_model.dart';
import 'package:sonara/features/rooms/data/repositories/room_repository.dart';
import '../../auth/auth_notifier.dart';

class RoomNotifier extends AsyncNotifier<List<RoomModel>> {
  late RoomRepository _repository;

  @override
  Future<List<RoomModel>> build() async {
    _repository = ref.read(roomRepositoryProvider);

    final authState = ref.watch(authProvider);

    if (authState.status != AuthStatus.authenticated) {
      return [];
    }

    return _repository.fetchMyRooms();
  }

  Future<void> createRoom(RoomModel room) async {
    await _repository.createRoom(room);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchMyRooms());
  }

  Future<void> updateRoom(String id, Map<String, dynamic> updates) async {
    await _repository.updateRoom(id, updates);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchMyRooms());
  }

  Future<void> deleteRoom(String id) async {
    await _repository.deleteRoom(id);
    final current = state.value ?? [];
    state = AsyncData(current.where((r) => r.id != id).toList());
  }
}

final roomNotifierProvider =
    AsyncNotifierProvider<RoomNotifier, List<RoomModel>>(RoomNotifier.new);
