import 'package:flutter/material.dart';

class ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool muted;

  const ContactRow({
    super.key,
    required this.icon,
    required this.text,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: muted ? const Color(0x33FFFFFF) : const Color(0x66FFFFFF),
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: muted ? const Color(0x33FFFFFF) : const Color(0xCCFFFFFF),
              fontStyle: muted ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}