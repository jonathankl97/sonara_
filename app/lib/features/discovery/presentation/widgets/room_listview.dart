import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/discovery/data/enums/room_category.dart';
import 'package:sonara/features/discovery/presentation/providers/room_category_provider.dart';
import 'package:sonara/features/discovery/presentation/widgets/room_card.dart';

class RoomListView extends ConsumerStatefulWidget {
  final String filterCategory;

  const RoomListView({super.key, required this.filterCategory});

  @override
  ConsumerState<RoomListView> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends ConsumerState<RoomListView> {
  //final Set<String> _likedRoomIds = {};

  @override
  Widget build(BuildContext context) {
    final category = RoomCategory.fromValue(widget.filterCategory);
    final asyncData = ref.watch(roomListProvider(category));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          category.label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        actions: [
          // Filter-Icon
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                // TODO: Filter-Panel oeffnen
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: kAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune, color: kAccent, size: 18),
              ),
            ),
          ),
        ],
      ),
      // ── Karte-FAB ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Kartenansicht
        },
        backgroundColor: kAccent,
        icon: const Icon(Icons.map_outlined, color: Colors.white),
        label: const Text(
          'Karte',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: asyncData.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kAccent)),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFFF453A),
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                error.toString(),
                style: const TextStyle(color: Color(0x99FFFFFF), fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.invalidate(roomListProvider(category)),
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
        data: (rooms) {
          if (rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.search_off,
                    color: Color(0x66FFFFFF),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Keine Studios gefunden',
                    style: const TextStyle(
                      color: Color(0x99FFFFFF),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            itemCount: rooms.length,
            separatorBuilder: (_, _) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final room = rooms[index];
              return RoomCard(
                room: room,
                onTap: () {
                  context.push('/rooms/${room.id}');
                },
                imageHeight: 200,
              );
            },
          );
        },
      ),
    );
  }
}
