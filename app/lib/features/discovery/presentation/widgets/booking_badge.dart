import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';

class BookingBadge extends StatelessWidget {
  final Color backgroundColor;
  final bool sofortBuchbar;

  const BookingBadge({super.key, required this.backgroundColor, required this.sofortBuchbar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        sofortBuchbar ? 'Sofort buchbar' : 'Auf Anfrage',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: sofortBuchbar ? const Color.fromRGBO(66, 255, 98, 1) : kAccent,
        ),
      ),
    );
  }
}
