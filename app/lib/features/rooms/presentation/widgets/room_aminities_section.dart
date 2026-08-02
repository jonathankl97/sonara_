import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/shared/widgets/section_title.dart';

const _availableAmenities = [
  'WIFI',
  'Parkplatz',
  'Küche',
  'Bad',
  'Klimaanlage',
  'Aufzug',
  'Barrierefreiheit',
  'Lounge',
  'Lagerraum',
  'Raucherbereich',
];

class RoomAmenitiesSection extends StatelessWidget {
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const RoomAmenitiesSection({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  void _toggle(String amenity) {
    final updated = List<String>.from(selected);
    if (updated.contains(amenity)) {
      updated.remove(amenity);
    } else {
      updated.add(amenity);
    }
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Ausstattung'),
        const SizedBox(height: 8),
        const Text(
          'Wähle alle zutreffenden Merkmale aus.',
          style: TextStyle(fontSize: 13, color: Color(0x66FFFFFF)),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: _availableAmenities.map((amenity) {
            final isSelected = selected.contains(amenity);
            return GestureDetector(
              onTap: () => _toggle(amenity),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? kAccent.withValues(alpha: 0.15)
                      : const Color(0xFF1A1A1A),
                  border: Border.all(
                    color: isSelected ? kAccent : const Color(0x1AFFFFFF),
                    width: isSelected ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  amenity,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? kAccent : Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
