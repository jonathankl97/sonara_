import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/profile/shared/section_title.dart';
import 'package:sonara/shared/enums/service_enums.dart';

class BookingModeSection extends StatelessWidget {
  final BookingMode selected;
  final ValueChanged<BookingMode> onChanged;

  const BookingModeSection({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Wie möchtest du Buchungen verwalten?'),
        const SizedBox(height: 12),
        _buildRadioTile(
          label: 'Buchung auf Anfrage (kein Kalender)',
          value: BookingMode.onRequest,
        ),
        _buildRadioTile(
          label: 'Feste wöchentliche Verfügbarkeit',
          value: BookingMode.weeklyAvailability,
        ),
      ],
    );
  }

  Widget _buildRadioTile({required String label, required BookingMode value}) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Radio<BookingMode>(
              value: value,
              groupValue: selected,
              activeColor: kAccent,
              onChanged: (v) => onChanged(v!),
            ),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
