import 'package:flutter/material.dart';
import 'package:sonara/features/auth/sign_up_screen.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? cta;
  final VoidCallback? onTap;

  const EmptyState({
    super.key,
    required this.icon,
    required this.text,
    this.cta,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: kAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: kAccent, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Color(0x40FFFFFF)),
        ),
        if (cta != null) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Text(
              cta!,
              style: const TextStyle(
                fontSize: 13,
                color: kAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
