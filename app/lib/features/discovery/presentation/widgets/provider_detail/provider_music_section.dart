import 'package:flutter/material.dart';
import 'package:sonara/features/profile/data/music_track_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderMusicSection extends StatelessWidget {
  final List<MusicTrackModel> tracks;

  const ProviderMusicSection({super.key, required this.tracks});

  Future<void> _openTrack(MusicTrackModel track) async {
    final uri = Uri.parse(track.spotifyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Musik',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tracks.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final track = tracks[index];
              return GestureDetector(
                onTap: () => _openTrack(track),
                child: SizedBox(
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Album Cover
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          track.albumImage,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 140,
                            height: 140,
                            color: const Color(0xFF2A2A2A),
                            child: const Icon(
                              Icons.music_note,
                              color: Color(0x33FFFFFF),
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Track Name
                      Text(
                        track.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Artists
                      Text(
                        track.artists.join(', '),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0x66FFFFFF),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
