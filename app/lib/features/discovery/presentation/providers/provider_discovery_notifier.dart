import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/features/discovery/data/models/provider_search_result.dart';
import 'package:sonara/features/discovery/data/repositories/discovery_repository.dart';
import 'provider_filter_state.dart';

class ProviderDiscoveryState {
  final List<ProviderSearchResult> providers;
  final int total;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const ProviderDiscoveryState({
    this.providers = const [],
    this.total = 0,
    this.currentPage = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  ProviderDiscoveryState copyWith({
    List<ProviderSearchResult>? providers,
    int? total,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ProviderDiscoveryState(
      providers: providers ?? this.providers,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ProviderDiscoveryNotifier
    extends AsyncNotifier<ProviderDiscoveryState> {
  late DiscoveryRepository _repository;

  @override
  Future<ProviderDiscoveryState> build() async {
    _repository = ref.read(discoveryRepositoryProvider);

    // Reagiert auf Filter-Aenderungen: bei jedem Update wird build() neu
    // ausgefuehrt und fetcht mit den neuen Filtern.
    final filters = ref.watch(providerFilterProvider);

    final result = await _repository.searchProviders(
      serviceType: filters.serviceType,
      genres: filters.genresParam,
      location: filters.remoteOnly ? 'remote' : filters.location,
      minPrice: filters.minPrice,
      maxPrice: filters.maxPrice,
      city: filters.city,
    );

    return ProviderDiscoveryState(
      providers: result.data,
      total: result.total,
      currentPage: result.page,
      hasMore: result.hasMore,
    );
  }

  /// Naechste Seite laden (fuer Infinite Scrolling).
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final filters = ref.read(providerFilterProvider);
    final nextPage = current.currentPage + 1;

    final result = await _repository.searchProviders(
      serviceType: filters.serviceType,
      genres: filters.genresParam,
      location: filters.remoteOnly ? 'remote' : filters.location,
      minPrice: filters.minPrice,
      maxPrice: filters.maxPrice,
      city: filters.city,
      page: nextPage,
    );

    state = AsyncData(ProviderDiscoveryState(
      providers: [...current.providers, ...result.data],
      total: result.total,
      currentPage: nextPage,
      hasMore: result.hasMore,
    ));
  }
}

final providerDiscoveryProvider = AsyncNotifierProvider<
    ProviderDiscoveryNotifier, ProviderDiscoveryState>(
  ProviderDiscoveryNotifier.new,
);
