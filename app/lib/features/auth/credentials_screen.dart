import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonara/core/theme/app_theme.dart';


class CredentialsScreen extends StatefulWidget {
  final String role;

  const CredentialsScreen({super.key, required this.role});

  @override
  State<CredentialsScreen> createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _onValidate() {
    final isValid = _formKey.currentState?.validate();

    if (isValid == true) {
      context.push(
        '/signup/roles/${widget.role}',
        extra: {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'address': _addressController.text.trim(),
          'zip': _zipController.text.trim(),
          'city': _cityController.text.trim(),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isProvider = widget.role == 'provider';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Account anlegen',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isProvider
                            ? 'Biete deine Services Künstlern an.'
                            : 'Finde die perfekten Kollaboratoren für deine Musik.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0x66FFFFFF),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D0D0D),
                          border: Border.all(color: const Color(0x1AFFFFFF)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Vollständiger Name'),
                            const SizedBox(height: 8),
                            _buildField(
                              controller: _nameController,
                              hint: 'John Doe',
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Bitte Namen eingeben';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildLabel('Email'),
                            const SizedBox(height: 8),
                            _buildField(
                              controller: _emailController,
                              hint: 'your@email.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Bitte Email eingeben';
                                }
                                final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );
                                if (!emailRegex.hasMatch(v.trim())) {
                                  return 'Ungültige Email-Adresse';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildLabel('Passwort'),
                            const SizedBox(height: 8),
                            _buildField(
                              controller: _passwordController,
                              hint: '••••••••',
                              obscure: _obscurePassword,
                              suffix: GestureDetector(
                                onTap: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: const Color(0x66FFFFFF),
                                  size: 18,
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Bitte Passwort eingeben';
                                }
                                if (v.length < 6) {
                                  return 'Mindestens 6 Zeichen';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildLabel('Adresse'),
                            const SizedBox(height: 8),
                            _buildField(
                              controller: _addressController,
                              hint: 'Musterstraße 23',
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Bitte Adresse eingeben';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('PLZ'),
                                      const SizedBox(height: 8),
                                      _buildField(
                                        controller: _zipController,
                                        hint: '12345',
                                        keyboardType: TextInputType.number,
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return 'Pflichtfeld';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('Wohnort'),
                                      const SizedBox(height: 8),
                                      _buildField(
                                        controller: _cityController,
                                        hint: 'Berlin',
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return 'Pflichtfeld';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _onValidate,
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
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Du hast bereits ein Konto? ',
                            style: TextStyle(
                              color: Color(0x66FFFFFF),
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/signin'),
                            child: const Text(
                              'Anmelden',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0x33FFFFFF), fontSize: 14),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF453A), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF453A), width: 1.5),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFF453A), fontSize: 11),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }
}
