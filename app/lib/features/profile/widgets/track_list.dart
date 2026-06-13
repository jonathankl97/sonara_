import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/models/music_track_model.dart';
import 'package:sonara/features/profile/user_provider.dart';
import 'package:sonara/features/profile/widgets/track_card.dart';

class TrackList extends ConsumerWidget {
  final List<MusicTrackModel> tracks;
  final bool showDelete;

  const TrackList({super.key, required this.tracks, this.showDelete = false});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String trackId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Song entfernen?',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: const Text(
          'Möchtest du diesen Song wirklich entfernen?',
          style: TextStyle(color: Color(0x99FFFFFF), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Abbrechen',
              style: TextStyle(color: Color(0x66FFFFFF)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Entfernen',
              style: TextStyle(color: Color(0xFFFF453A)),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(userProvider.notifier).removeMusicTrack(trackId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 240),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tracks.length,
        itemBuilder: (ctx, index) => TrackCard(
          track: tracks[index],
          onDelete: showDelete
              ? () => _confirmDelete(context, ref, tracks[index].id)
              : null,
          showPlatformButtons: !showDelete,
        ),
      ),
    );
  }
}
