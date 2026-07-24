import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';

class ProfileCompleteBanner extends StatelessWidget {
  final double completeness;
  const ProfileCompleteBanner({super.key, required this.completeness});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kAccent.withValues(alpha: 0.08),
        border: Border.all(color: kAccent.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profil vervollständigen',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kAccent,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Füge Bio, Genres und Social Media hinzu um mehr Buchungen zu erhalten.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0x66FFFFFF),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: completeness,
              backgroundColor: const Color(0x1AFFFFFF),
              valueColor: const AlwaysStoppedAnimation<Color>(kAccent),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}
