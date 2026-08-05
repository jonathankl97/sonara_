import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
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

  Future<void> createRoom({
    required RoomModel room,
    required List<String> localImagePaths,
  }) async {
    if (localImagePaths.isEmpty) {
      throw Exception('Mindestens ein Foto erforderlich');
    }

    final List<Reference> uploadedRefs = [];

    try {
      // 1. Bilder zu Firebase Storage hochladen
      final List<String> imageUrls = [];
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        for (final path in localImagePaths) {
          final fileName = const Uuid().v4();
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('room_images')
              .child(uid)
              .child('$fileName.jpg');

          await storageRef.putFile(File(path));
          final url = await storageRef.getDownloadURL();

          imageUrls.add(url);
          uploadedRefs.add(storageRef);
        }
      }

      // 2. Room mit den Upload-URLs erstellen
      final roomWithImages = RoomModel(
        name: room.name,
        description: room.description,
        roomType: room.roomType,
        priceModel: room.priceModel,
        bookingMode: room.bookingMode,
        basePrice: room.basePrice,
        sizeSqm: room.sizeSqm,
        capacity: room.capacity,
        address: room.address,
        city: room.city,
        zip: room.zip,
        state: room.state,
        country: room.country,
        amenities: room.amenities,
        equipment: room.equipment,
        imageUrls: imageUrls,
        openingHours: room.openingHours,
      );

      // 3. An Backend senden + Liste neu laden
      await _repository.createRoom(roomWithImages);
      state = const AsyncLoading();
      state = await AsyncValue.guard(() => _repository.fetchMyRooms());
    } on Exception {
      // Bei jedem Fehler: hochgeladene Bilder wieder loeschen
      for (final ref in uploadedRefs) {
        try {
          await ref.delete();
        } catch (_) {}
      }
      rethrow;
    }
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

  Future<void> uploadAndUpdateRoom({
    required String roomId,
    required Map<String, dynamic> updates,
    required List<String> localImagePaths,
    required List<String> existingImageUrls,
  }) async {
    final List<Reference> uploadedRefs = [];

    try {
      final List<String> newImageUrls = [];
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        for (final path in localImagePaths) {
          final fileName = const Uuid().v4();
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('room_images')
              .child(uid)
              .child('$fileName.jpg');

          await storageRef.putFile(File(path));
          final url = await storageRef.getDownloadURL();

          newImageUrls.add(url);
          uploadedRefs.add(storageRef);
        }
      }

      // Bestehende + neue URLs kombinieren
      updates['imageUrls'] = [...existingImageUrls, ...newImageUrls];

      await _repository.updateRoom(roomId, updates);
      state = const AsyncLoading();
      state = await AsyncValue.guard(() => _repository.fetchMyRooms());
    } on Exception {
      for (final ref in uploadedRefs) {
        try {
          await ref.delete();
        } catch (_) {}
      }
      rethrow;
    }
  }
}

final roomNotifierProvider =
    AsyncNotifierProvider<RoomNotifier, List<RoomModel>>(RoomNotifier.new);
