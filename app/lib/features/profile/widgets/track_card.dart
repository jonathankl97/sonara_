import 'package:flutter/material.dart';
import 'package:sonara/core/models/music_track_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackCard extends StatelessWidget {
  final MusicTrackModel track;
  final VoidCallback? onDelete;
  final bool showPlatformButtons;

  const TrackCard({
    super.key,
    required this.track,
    this.onDelete,
    this.showPlatformButtons = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                track.albumImage,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 52,
                  height: 52,
                  color: const Color(0xFF2A2A2A),
                  child: const Icon(
                    Icons.music_note_rounded,
                    color: Color(0x66FFFFFF),
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.artists.join(', '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0x66FFFFFF),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                if (showPlatformButtons) ...[
                  GestureDetector(
                    onTap: () async {
                      try {
                        await launchUrl(
                          Uri.parse(track.spotifyUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      } catch (_) {}
                    },
                    child: Image.asset(
                      'assets/icons/spotify_logo.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  if (track.appleMusicUrl != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        try {
                          await launchUrl(
                            Uri.parse(track.appleMusicUrl!),
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (_) {}
                      },
                      child: Image.asset(
                        'assets/icons/apple_music_logo.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ],
                if (onDelete != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0x66FFFFFF),
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
