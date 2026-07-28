import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/shared/widgets/section_title.dart';
import 'package:sonara/features/services/presentation/widgets/form_helpers.dart';

const _weekdays = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

const _weekdayLabels = {
  'monday': 'Mo',
  'tuesday': 'Di',
  'wednesday': 'Mi',
  'thursday': 'Do',
  'friday': 'Fr',
  'saturday': 'Sa',
  'sunday': 'So',
};

class RoomOpeningHoursSection extends StatelessWidget {
  final List<String> selectedDays;
  final ValueChanged<List<String>> onDaysChanged;
  final TextEditingController openFromController;
  final TextEditingController openToController;

  const RoomOpeningHoursSection({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
    required this.openFromController,
    required this.openToController,
  });

  void _toggleDay(String day) {
    final updated = List<String>.from(selectedDays);
    if (updated.contains(day)) {
      updated.remove(day);
    } else {
      updated.add(day);
    }
    onDaysChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Öffnungszeiten'),
        const SizedBox(height: 8),
        const Text(
          'An welchen Tagen ist dein Raum verfügbar?',
          style: TextStyle(fontSize: 13, color: Color(0x66FFFFFF)),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: _weekdays.map((day) {
            final isSelected = selectedDays.contains(day);
            return GestureDetector(
              onTap: () => _toggleDay(day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? kAccent.withValues(alpha: 0.15)
                      : const Color(0xFF1A1A1A),
                  border: Border.all(
                    color: isSelected ? kAccent : const Color(0x1AFFFFFF),
                    width: isSelected ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _weekdayLabels[day] ?? day,
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
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel('Von'),
                  const SizedBox(height: 8),
                  FormTextField(controller: openFromController, hint: '09:00'),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel('Bis'),
                  const SizedBox(height: 8),
                  FormTextField(controller: openToController, hint: '22:00'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
