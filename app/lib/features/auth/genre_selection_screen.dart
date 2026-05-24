import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'sign_up_screen.dart';

const _genres = [
  'HipHop', 'Pop', 'Rock', 'Trap', 'R&B', 'Jazz',
  'Electronic', 'Classical', 'Country', 'Reggae',
  'Metal', 'Folk', 'Blues', 'Indie', 'Soul', 'Funk',
  'Punk', 'Latin',
];

class GenreSelectionScreen extends ConsumerStatefulWidget {
  final String role;
  final Map<String, dynamic> credentials;

  const GenreSelectionScreen({
    super.key,
    required this.role,
    required this.credentials,
  });

  @override
  ConsumerState<GenreSelectionScreen> createState() =>
      _GenreSelectionScreenState();
}

class _GenreSelectionScreenState extends ConsumerState<GenreSelectionScreen> {
  final Set<String> _selected = {};
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    // TODO: Firebase Registration + Backend Call kommt hier
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Welche Genres bietest du an?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Wähle alle zutreffenden Genres aus (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0x66FFFFFF),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: _genres.map((tag) {
                        final isSelected = _selected.contains(tag);
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (isSelected) {
                              _selected.remove(tag);
                            } else {
                              _selected.add(tag);
                            }
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? kAccent.withOpacity(0.15)
                                  : const Color(0xFF1A1A1A),
                              border: Border.all(
                                color: isSelected
                                    ? kAccent
                                    : const Color(0x1AFFFFFF),
                                width: isSelected ? 1.5 : 1,
                              ),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? kAccent : Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              'Konto erstellen',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _submit,
                      child: const Text(
                        'Überspringen',
                        style: TextStyle(
                          color: Color(0x66FFFFFF),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}