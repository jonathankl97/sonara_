import 'package:flutter/material.dart';
import 'package:sonara/features/auth/sign_up_screen.dart';

class SwitchRoleBanner extends StatelessWidget {
  const SwitchRoleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x1AFFFFFF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.settings_outlined, color: kAccent, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Biete deine Dienste an',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Bist du Produzent, Engineer oder Studiobesitzer? Wechsel jetzt in den Provider Modus und erhalte deine ersten Buchungen.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0x66FFFFFF),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Werde Provider',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
