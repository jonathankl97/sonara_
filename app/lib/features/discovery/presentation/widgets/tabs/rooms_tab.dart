import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonara/features/discovery/presentation/providers/room_discovery_notifier.dart';
import 'package:sonara/features/discovery/presentation/widgets/room_card.dart';
import 'package:sonara/features/discovery/presentation/widgets/section_header.dart';

class RoomsTab extends ConsumerWidget {
  const RoomsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryAsync = ref.watch(roomDiscoveryProvider);

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
              onPressed: () => ref.invalidate(roomDiscoveryProvider),
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
      data: (state) {
        if (state.rooms.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off, color: Color(0x66FFFFFF), size: 48),
                SizedBox(height: 12),
                Text(
                  'Keine Räume gefunden',
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
              DiscoverySectionHeader(
                title: 'Beliebte Studios',
                onShowAll: () {
                  context.push('/discovery/rooms/category/popular');
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.rooms.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return RoomCard(
                      room: state.rooms[index],
                      width: 200,
                      onTap: () {
                        context.push('/rooms/${state.rooms[index].id}');
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              DiscoverySectionHeader(
                title: 'Studios in deiner Nähe',
                onShowAll: () {
                  context.push('/discovery/rooms/category/nearby');
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.rooms.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return RoomCard(
                      room: state.rooms[index],
                      width: 200,
                      onTap: () {
                        context.push('/rooms/${state.rooms[index].id}');
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