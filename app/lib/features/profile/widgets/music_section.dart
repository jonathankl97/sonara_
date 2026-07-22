import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/widgets/error_snackbar.dart';
import 'package:sonara/features/profile/user_provider.dart';
import 'package:sonara/features/profile/widgets/add_track_sheet.dart';
import 'package:sonara/features/profile/widgets/track_list.dart';
import '../shared/section_title.dart';
import '../shared/empty_state.dart';
import 'package:sonara/core/theme/app_theme.dart';

class MusicSection extends ConsumerWidget {
  const MusicSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = ref.watch(
      userProvider.select((async) => async.value?.musicTracks ?? []),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SectionTitle('Meine Musik'),
              if (tracks.isNotEmpty)
                GestureDetector(
                  onTap: () => _openSheet(context, ref),
                  child: const Text(
                    'Bearbeiten',
                    style: TextStyle(
                      fontSize: 13,
                      color: kAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 30),
          if (tracks.isNotEmpty)
            TrackList(tracks: tracks, showDelete: false)
          else
            EmptyState(
              icon: Icons.music_note_rounded,
              text: 'Noch keine Musik hinzugefügt',
              cta: '+ Song hinzufügen',
              onTap: () => _openSheet(context, ref),
            ),
        ],
      ),
    );
  }

  void _openSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => AddTrackSheet(
        onSave: (pendingTracks) async {
          try {
            for (final track in pendingTracks) {
              await ref
                  .read(userProvider.notifier)
                  .addMusicTrack(track.spotifyUrl, track.appleMusicUrl);
            }
            if (ctx.mounted) Navigator.pop(ctx);
          } catch (e) {
            if (ctx.mounted) showErrorSnackbar(ctx, e);
          }
        },
      ),
    );
  }
}
