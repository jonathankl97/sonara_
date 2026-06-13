import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/models/pending_track.dart';
import 'package:sonara/features/auth/sign_up_screen.dart';
import 'package:sonara/features/profile/user_provider.dart';
import 'package:sonara/features/profile/widgets/track_list.dart';

class AddTrackSheet extends ConsumerStatefulWidget {
  final Future<void> Function(List<PendingTrack> newTracks) onSave;

  const AddTrackSheet({super.key, required this.onSave});

  @override
  ConsumerState<AddTrackSheet> createState() => _AddTrackSheetState();
}

class _AddTrackSheetState extends ConsumerState<AddTrackSheet> {
  final List<PendingTrack> _pendingTracks = [];
  bool _isLoading = false;
  bool _showAddForm = false;

  final _spotifyController = TextEditingController();
  final _appleMusicController = TextEditingController();
  bool _isFetchingTrack = false;

  @override
  void dispose() {
    _spotifyController.dispose();
    _appleMusicController.dispose();
    super.dispose();
  }

  Future<void> _fetchAndAddTrack() async {
    if (_spotifyController.text.trim().isEmpty) return;
    setState(() => _isFetchingTrack = true);

    setState(() {
      _pendingTracks.add(
        PendingTrack(
          spotifyUrl: _spotifyController.text.trim(),
          appleMusicUrl: _appleMusicController.text.trim().isEmpty
              ? null
              : _appleMusicController.text.trim(),
        ),
      );
      _spotifyController.clear();
      _appleMusicController.clear();
      _showAddForm = false;
      _isFetchingTrack = false;
    });
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    await widget.onSave(_pendingTracks);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final existingTracks = ref.watch(
      userProvider.select((async) => async.value?.musicTracks ?? []),
    );

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
              'Meine Musik',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            if (existingTracks.isNotEmpty) ...[
              const Text(
                'Gespeicherte Songs',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0x66FFFFFF),
                ),
              ),
              const SizedBox(height: 8),
              TrackList(tracks: existingTracks, showDelete: true),
              const SizedBox(height: 8),
            ],
            if (_pendingTracks.isNotEmpty) ...[
              const Text(
                'Neu hinzugefügt',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0x66FFFFFF),
                ),
              ),
              const SizedBox(height: 8),
              ..._pendingTracks.asMap().entries.map((entry) {
                final track = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kAccent.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.music_note_rounded,
                          color: kAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            track.spotifyUrl,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            _pendingTracks.removeAt(entry.key);
                          }),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Color(0x66FFFFFF),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
            if (_showAddForm) ...[
              const Text(
                'Spotify URL',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _spotifyController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'https://open.spotify.com/track/...',
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
                    borderSide: const BorderSide(color: kAccent, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Apple Music URL (optional)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _appleMusicController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'https://music.apple.com/...',
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
                    borderSide: const BorderSide(color: kAccent, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _showAddForm = false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0x1AFFFFFF)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Abbrechen'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isFetchingTrack ? null : _fetchAndAddTrack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isFetchingTrack
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Hinzufügen'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ] else ...[
              GestureDetector(
                onTap: () => setState(() => _showAddForm = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: kAccent.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, color: kAccent, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Song hinzufügen',
                        style: TextStyle(
                          fontSize: 13,
                          color: kAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
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
