import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'sign_up_screen.dart';

const _roles = [
  'Produzent',
  'Beat Maker',
  'DJ',
  'Mixing Engineer',
  'Mastering Engineer',
  'Instrumentalist',
  'Studiobesitzer',
  'Songwriter',
  'Sounddesigner',
];

class RolesSelectionScreen extends ConsumerStatefulWidget {
  final String role;
  final Map<String, String> credentials;

  const RolesSelectionScreen({
    super.key,
    required this.role,
    required this.credentials,
  });

  @override
  ConsumerState<RolesSelectionScreen> createState() =>
      _RolesSelectionScreenState();
}

class _RolesSelectionScreenState extends ConsumerState<RolesSelectionScreen> {
  final Set<String> _selected = {};

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Was beschreibt dich am besten?',
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
                      'Wähle alle zutreffenden Rollen aus',
                      style: TextStyle(fontSize: 14, color: Color(0x66FFFFFF)),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: _roles.map((tag) {
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
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => context.push(
                        '/signup/genres/${widget.role}',
                        extra: {
                          ...widget.credentials,
                          'roles': _selected.join(','),
                        },
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Weiter',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
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
