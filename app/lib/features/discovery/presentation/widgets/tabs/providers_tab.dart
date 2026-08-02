import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/features/discovery/presentation/providers/provider_discovery_notifier.dart';
import 'package:sonara/features/discovery/presentation/widgets/provider_card.dart';
import 'package:sonara/features/discovery/presentation/widgets/section_header.dart';

class ProvidersTab extends ConsumerWidget {
  const ProvidersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryAsync = ref.watch(providerDiscoveryProvider);

    return discoveryAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF9142)),
      ),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFFF453A), size: 40),
            const SizedBox(height: 12),
            Text(
              error.toString(),
              style: const TextStyle(color: Color(0x99FFFFFF), fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => ref.invalidate(providerDiscoveryProvider),
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
      data: (state) {
        if (state.providers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off, color: Color(0x66FFFFFF), size: 48),
                SizedBox(height: 12),
                Text(
                  'Keine Provider gefunden',
                  style: TextStyle(color: Color(0x99FFFFFF), fontSize: 15),
                ),
                SizedBox(height: 4),
                Text(
                  'Versuche andere Filter',
                  style: TextStyle(color: Color(0x66FFFFFF), fontSize: 13),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Sektion: Top Bewertung
              DiscoverySectionHeader(
                title: 'Top Bewertung',
                onShowAll: () {
                  // TODO: Zur vollstaendigen Liste navigieren
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 240,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.providers.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final provider = state.providers[index];
                    return ProviderCard(
                      provider: provider,
                      onTap: () {
                        // TODO: Provider-Detail-Screen navigieren
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              // Sektion: Sofort buchbar
              DiscoverySectionHeader(
                title: 'Sofort buchbar',
                onShowAll: () {
                  // TODO: Gefilterte Liste
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 240,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.providers
                      .where((p) => p.hasSofortBuchbar)
                      .length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final sofortBuchbar = state.providers
                        .where((p) => p.hasSofortBuchbar)
                        .toList();
                    if (index >= sofortBuchbar.length) {
                      return const SizedBox();
                    }
                    return ProviderCard(
                      provider: sofortBuchbar[index],
                      onTap: () {
                        // TODO: Provider-Detail-Screen
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
