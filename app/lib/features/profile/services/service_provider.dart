import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/models/service_model.dart';
import 'package:sonara/core/repositories/service_repository.dart';
import '../../auth/auth_notifier.dart';

class ServiceNotifier extends AsyncNotifier<List<ServiceModel>> {
  late ServiceRepository _repository;

  @override
  Future<List<ServiceModel>> build() async {
    _repository = ref.read(serviceRepositoryProvider);

    final authState = ref.watch(authProvider);

    if (authState.status != AuthStatus.authenticated) {
      return [];
    }

    // Repository wirft AppException; AsyncNotifier faengt sie automatisch
    // und setzt AsyncError.
    return _repository.fetchMyServices();
  }

  Future<void> createService(ServiceModel service) async {
    await _repository.createService(service);
    // Liste neu laden, damit der neue Service sofort sichtbar ist.
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchMyServices());
  }

  Future<void> updateService(String id, Map<String, dynamic> updates) async {
    await _repository.updateService(id, updates);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchMyServices());
  }

  Future<void> deleteService(String id) async {
    await _repository.deleteService(id);
    // Optimistisch aus der lokalen Liste entfernen, statt neu zu laden.
    final current = state.value ?? [];
    state = AsyncData(current.where((s) => s.id != id).toList());
  }
}

final serviceNotifierProvider =
    AsyncNotifierProvider<ServiceNotifier, List<ServiceModel>>(
      ServiceNotifier.new,
    );
