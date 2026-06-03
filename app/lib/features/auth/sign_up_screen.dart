import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const kAccent = Color(0xFFFF9142);

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: kAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sonara',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vernetze dich mit den richtigen Musikprofis.',
                    style: TextStyle(fontSize: 14, color: Color(0x66FFFFFF)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  _RoleCard(
                    icon: Icons.mic_rounded,
                    title: 'Ich bin ein Künstler',
                    subtitle:
                        'Finde Studios, Produzenten und Engineers für dein nächstes Projekt',
                    isAccent: true,
                    onTap: () => context.push('/signup/credentials/artist'),
                  ),
                  const SizedBox(height: 12),
                  _RoleCard(
                    icon: Icons.headphones_rounded,
                    title: 'Ich bin ein Dienstleister',
                    subtitle:
                        'Biete dein Studio, deine Produktion oder weitere Dienstleistungen an',
                    isAccent: false,
                    onTap: () => context.push('/signup/credentials/provider'),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Du hast bereits ein Konto? ',
                        style: TextStyle(
                          color: Color(0x66FFFFFF),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/signin'),
                        child: const Text(
                          'Melde dich an',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isAccent;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isAccent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          border: Border.all(
            color: isAccent ? kAccent : const Color(0x1AFFFFFF),
            width: isAccent ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isAccent
                    ? kAccent.withOpacity(0.15)
                    : const Color(0x0FFFFFFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isAccent ? kAccent : Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0x66FFFFFF),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0x33FFFFFF),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
