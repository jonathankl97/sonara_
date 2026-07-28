import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/features/rooms/presentation/room_provider.dart';
import 'package:sonara/features/rooms/presentation/widgets/room_card.dart';
import 'package:sonara/shared/widgets/section_title.dart';

class RoomsList extends ConsumerWidget {
  const RoomsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomssAsync = ref.watch(roomNotifierProvider);

    return roomssAsync.when(
      data: (rooms) {
        if (rooms.isEmpty) {
          return const Text('Du hast noch keine Services erstellt.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle('Meine Vermietungen'),
            const SizedBox(height: 30),
            // ListView.builder rendert nur die sichtbaren Elemente
            ListView.separated(
              shrinkWrap:
                  true, // Nötig, wenn die Column in einer ScrollView liegt
              physics:
                  const NeverScrollableScrollPhysics(), // Scrollen dem Parent überlassen
              itemCount: rooms.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final room = rooms[index];
                return RoomCard(room: room);
              },
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    );
  }
}
