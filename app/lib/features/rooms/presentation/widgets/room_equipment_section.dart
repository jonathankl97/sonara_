import 'package:flutter/material.dart';
import 'package:sonara/features/rooms/data/models/room_equipment_model.dart';
import 'package:sonara/shared/widgets/section_title.dart';
import 'package:sonara/features/rooms/data/enums/room_enums.dart';
import 'package:sonara/shared/widgets/form_helpers.dart';

class RoomEquipmentSection extends StatelessWidget {
  final List<EquipmentEntry> entries;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final void Function(int index, RoomEquipmentCategory category)
  onCategoryChanged;

  const RoomEquipmentSection({
    super.key,
    required this.entries,
    required this.onAdd,
    required this.onRemove,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Equipment'),
        const SizedBox(height: 8),
        const Text(
          'Liste das verfügbare Equipment auf.',
          style: TextStyle(fontSize: 13, color: Color(0x66FFFFFF)),
        ),
        const SizedBox(height: 12),
        ...entries.asMap().entries.map((entry) {
          final i = entry.key;
          final eq = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              border: Border.all(color: const Color(0x1AFFFFFF)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Gerät ${i + 1}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onRemove(i),
                      child: const Icon(
                        Icons.remove_circle_outline,
                        color: Color(0xFFFF453A),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const FormLabel('Kategorie'),
                const SizedBox(height: 6),
                FormDropdown<RoomEquipmentCategory>(
                  value: eq.category,
                  items: RoomEquipmentCategory.values,
                  labels: categoryLabels,
                  onChanged: (v) {
                    if (v != null) onCategoryChanged(i, v);
                  },
                ),
                const SizedBox(height: 10),
                const FormLabel('Bezeichnung'),
                const SizedBox(height: 6),
                FormTextField(
                  controller: eq.nameController,
                  hint: 'z.B. Logic Pro, Neumann U87',
                ),
              ],
            ),
          );
        }),
        FormAddButton(label: 'Equipment hinzufügen', onTap: onAdd),
      ],
    );
  }
}
