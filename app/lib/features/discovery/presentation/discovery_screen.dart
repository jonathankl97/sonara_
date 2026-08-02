import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/discovery/presentation/providers/provider_filter_state.dart';
import 'package:sonara/features/discovery/presentation/providers/room_filter_state.dart';
import 'package:sonara/features/discovery/presentation/widgets/discovery_search_bar.dart';
import 'package:sonara/features/discovery/presentation/widgets/discovery_tab_bar.dart';
import 'package:sonara/features/discovery/presentation/widgets/provider_filter_panel.dart';
import 'package:sonara/features/discovery/presentation/widgets/tabs/providers_tab.dart';
import 'package:sonara/features/discovery/presentation/widgets/room_filter_panel.dart';
import 'package:sonara/features/discovery/presentation/widgets/tabs/rooms_tab.dart';
import 'package:sonara/features/profile/presentation/user_provider.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _isRoomsTab => _tabController.index == 0;

  void _openFilterPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _isRoomsTab ? const RoomFilterPanel() : const ProviderFilterPanel(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // ── Greeting (nur displayName, via Consumer + select) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final displayName = ref.watch(
                        userProvider.select((u) => u.value?.displayName),
                      );
                      return Text(
                        'Hallo, ${displayName?.split(' ').first ?? ''}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      );
                    },
                  ),
                  // Kalender-Icon (Platzhalter fuer Verfuegbarkeits-Feature)
                  GestureDetector(
                    onTap: () {
                      context.pushReplacement('/bookings');
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: kAccent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: kAccent,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ── Suchleiste + Filter-Button ──
            Consumer(
              builder: (context, ref, _) {
                final hasFilters = _isRoomsTab
                    ? ref.watch(roomFilterProvider).hasActiveFilters
                    : ref.watch(providerFilterProvider).hasActiveFilters;
                return DiscoverySearchBar(
                  onFilterTap: () => _openFilterPanel(context),
                  hasActiveFilters: hasFilters,
                );
              },
            ),
            const SizedBox(height: 16),
            // ── Tab-Bar ──
            DiscoveryTabBar(controller: _tabController),
            // ── Tab-Content ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [RoomsTab(), ProvidersTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
