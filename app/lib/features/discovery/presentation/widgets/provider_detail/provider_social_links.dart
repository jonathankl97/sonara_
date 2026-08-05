import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/shared/models/social_media_model.dart';
import 'package:url_launcher/url_launcher.dart';

const _platformIcons = {
  'Instagram': Icons.camera_alt_outlined,
  'YouTube': Icons.play_circle_outline,
  'Spotify': Icons.music_note_outlined,
  'TikTok': Icons.videocam_outlined,
  'SoundCloud': Icons.cloud_outlined,
  'Apple Music': Icons.apple,
};

class ProviderSocialLinks extends StatelessWidget {
  final SocialMediaModel socialMedia;

  const ProviderSocialLinks({super.key, required this.socialMedia});

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!socialMedia.hasAny) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Social Media',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: socialMedia.entries.map((entry) {
            return GestureDetector(
              onTap: () => _openLink(entry.value),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x1AFFFFFF)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _platformIcons[entry.key] ?? Icons.link,
                      color: kAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
