import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/rooms/data/models/opening_hours_model.dart';
import 'package:sonara/shared/enums/weekday.dart';

class RoomOpeningHoursInfo extends StatelessWidget {
  final OpeningHoursModel openingHours;

  const RoomOpeningHoursInfo({super.key, required this.openingHours});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Öffnungszeiten',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.access_time, color: Color(0x99FFFFFF), size: 18),
            const SizedBox(width: 8),
            Text(
              '${openingHours.openFrom} – ${openingHours.openTo}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: openingHours.days.map((day) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: kAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kAccent),
              ),
              child: Text(
                Weekday.fromValue(day).label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kAccent,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
