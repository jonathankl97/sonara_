import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';

class RoomPriceCard extends StatelessWidget {
  final String priceLabel;

  const RoomPriceCard({super.key, required this.priceLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Preis',
            style: TextStyle(fontSize: 15, color: Color(0x99FFFFFF)),
          ),
          Text(
            priceLabel,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: kAccent,
            ),
          ),
        ],
      ),
    );
  }
}
