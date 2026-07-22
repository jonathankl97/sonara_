import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/widgets/error_snackbar.dart';
import 'package:sonara/features/profile/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/section_title.dart';
import '../shared/empty_state.dart';
import 'package:sonara/core/theme/app_theme.dart';

class SocialMediaSection extends ConsumerWidget {
  const SocialMediaSection({super.key});

  static const _platforms = [
    _Platform(
      'instagram',
      'Instagram',
      Icons.camera_alt_outlined,
      'https://instagram.com/',
    ),
    _Platform(
      'youtube',
      'YouTube',
      Icons.play_circle_outline_rounded,
      'https://youtube.com/@',
    ),
    _Platform(
      'spotify',
      'Spotify',
      Icons.music_note_rounded,
      'https://open.spotify.com/artist/',
    ),
    _Platform(
      'tiktok',
      'TikTok',
      Icons.music_video_outlined,
      'https://tiktok.com/@',
    ),
    _Platform(
      'soundcloud',
      'SoundCloud',
      Icons.cloud_outlined,
      'https://soundcloud.com/',
    ),
    _Platform(
      'appleMusic',
      'Apple Music',
      Icons.phone_iphone_outlined,
      'https://music.apple.com/',
    ),
  ];

  void _editSocialMedia(
    BuildContext context,
    WidgetRef ref,
    Map<String, String> current,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _SocialMediaBottomSheet(
        current: current,
        platforms: _platforms,
        onSave: (updated) async {
          try {
            await ref.read(userProvider.notifier).updateSocialMedia(updated);
            if (ctx.mounted) Navigator.pop(ctx);
          } catch (e) {
            if (ctx.mounted) showErrorSnackbar(ctx, e);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialMedia = ref.watch(
      userProvider.select((async) => async.value?.socialMedia ?? {}),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitle('Social Media'),
            if (socialMedia.isNotEmpty)
              GestureDetector(
                onTap: () => _editSocialMedia(context, ref, socialMedia),
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
        const SizedBox(height: 12),
        if (socialMedia.isNotEmpty)
          ...socialMedia.entries.map((entry) {
            final platform = _platforms.firstWhere(
              (p) => p.key == entry.key,
              orElse: () => _Platform(entry.key, entry.key, Icons.link, ''),
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () async {
                  try {
                    final uri = Uri.parse(entry.value);
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (_) {}
                },
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
                      Icon(platform.icon, color: kAccent, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        platform.label,
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
              ),
            );
          })
        else
          EmptyState(
            icon: Icons.share_outlined,
            text: 'Verknüpfe deine Social Media',
            cta: '+ Hinzufügen',
            onTap: () => _editSocialMedia(context, ref, socialMedia),
          ),
      ],
    );
  }
}

class _Platform {
  final String key;
  final String label;
  final IconData icon;
  final String placeholder;

  const _Platform(this.key, this.label, this.icon, this.placeholder);
}

class _SocialMediaBottomSheet extends StatefulWidget {
  final Map<String, String> current;
  final List<_Platform> platforms;
  final ValueChanged<Map<String, String>> onSave;

  const _SocialMediaBottomSheet({
    required this.current,
    required this.platforms,
    required this.onSave,
  });

  @override
  State<_SocialMediaBottomSheet> createState() =>
      _SocialMediaBottomSheetState();
}

class _SocialMediaBottomSheetState extends State<_SocialMediaBottomSheet> {
  late Map<String, TextEditingController> _controllers;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final p in widget.platforms)
        p.key: TextEditingController(text: widget.current[p.key] ?? ''),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    final updated = <String, String>{
      for (final entry in _controllers.entries)
        if (entry.value.text.trim().isNotEmpty)
          entry.key: entry.value.text.trim(),
    };
    widget.onSave(updated);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Social Media',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ...widget.platforms.map((p) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(p.icon, color: kAccent, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          p.label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _controllers[p.key],
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: p.placeholder,
                        hintStyle: const TextStyle(
                          color: Color(0x33FFFFFF),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: kAccent,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(
                      'Speichern',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
