import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonara/core/network/api_client.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/profile/presentation/user_provider.dart';
import 'package:sonara/shared/enums/genres.dart';

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

  String? _extractErrorMessage(dynamic data) {
    if (data is! Map) return null;
    final message = data['message'];
    if (message is String) return message;
    if (message is List) return message.join(', ');
    return null;
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      // 1. Firebase Registrierung
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: widget.credentials['email']!,
            password: widget.credentials['password']!,
          );

      await credential.user?.updateDisplayName(widget.credentials['name']);

      // 2. Roles robust auslesen — kann String oder List sein
      final dynamic rawRoles = widget.credentials['roles'];
      final List<String> rolesList;
      if (rawRoles is List) {
        rolesList = rawRoles.map((r) => r.toString()).toList();
      } else if (rawRoles is String && rawRoles.isNotEmpty) {
        rolesList = rawRoles.split(',').where((r) => r.isNotEmpty).toList();
      } else {
        rolesList = [];
      }

      // 3. Backend Call — User im Backend anlegen
      await apiClient.post(
        '/auth/register',
        data: {
          'name': widget.credentials['name'],
          'email': widget.credentials['email'],
          'address': widget.credentials['address'],
          'zip': widget.credentials['zip'],
          'city': widget.credentials['city'],
          'role': widget.role,
          'roles': rolesList,
          'genres': _selected.toList(),
        },
      );

      // 4. User existiert jetzt im Backend → userProvider neu laden,
      // damit der Redirect die Rolle sieht und weiterleitet.
      ref.invalidate(userProvider);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Registrierung fehlgeschlagen'),
            backgroundColor: const Color(0xFFFF453A),
          ),
        );
      }
    } on DioException catch (e) {
     
      await FirebaseAuth.instance.currentUser?.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _extractErrorMessage(e.response?.data) ?? 'Server Fehler',
            ),
            backgroundColor: const Color(0xFFFF453A),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                      style: TextStyle(fontSize: 14, color: Color(0x66FFFFFF)),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: genres.map((tag) {
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
                                  ? kAccent.withValues(alpha: 0.15)
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
