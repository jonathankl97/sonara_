import 'package:flutter/material.dart';
import 'package:sonara/core/models/user_model.dart';
import 'package:sonara/features/auth/sign_up_screen.dart';
import 'shared/section_title.dart';
import 'shared/empty_state.dart';

class SocialMediaSection extends StatelessWidget {
  final UserModel user;
  const SocialMediaSection({super.key, required this.user});

  static const _platformIcons = {
    'instagram': Icons.camera_alt_outlined,
    'youtube': Icons.play_circle_outline_rounded,
    'spotify': Icons.music_note_rounded,
    'tiktok': Icons.music_video_outlined,
    'soundcloud': Icons.cloud_outlined,
    'appleMusic': Icons.phone_iphone_outlined,
  };

  static const _platformLabels = {
    'instagram': 'Instagram',
    'youtube': 'YouTube',
    'spotify': 'Spotify',
    'tiktok': 'TikTok',
    'soundcloud': 'SoundCloud',
    'appleMusic': 'Apple Music',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: const SectionTitle('Social Media'),
        ),
        const SizedBox(height: 12),
        if (user.socialMedia.isNotEmpty)
          ...user.socialMedia.entries.map((entry) {
            final icon = _platformIcons[entry.key] ?? Icons.link;
            final label = _platformLabels[entry.key] ?? entry.key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: kAccent, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0x66FFFFFF),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        else
          EmptyState(
            icon: Icons.share_outlined,
            text: 'Verknüpfe deine Social Media',
            cta: '+ Hinzufügen',
            onTap: () {},
          ),
      ],
    );
  }
}
