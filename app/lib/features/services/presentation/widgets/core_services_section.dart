import 'package:flutter/material.dart';
import 'package:sonara/shared/widgets/section_title.dart';
import 'form_helpers.dart';

class CoreServicesSection extends StatelessWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const CoreServicesSection({
    super.key,
    required this.controllers,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Was beinhaltet dein Service?'),
        const SizedBox(height: 8),
        const Text(
          'Liste die Kernleistungen deines Service auf.',
          style: TextStyle(fontSize: 13, color: Color(0x66FFFFFF)),
        ),
        const SizedBox(height: 12),
        ...controllers.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: FormTextField(
                    controller: entry.value,
                    hint: 'z.B. EQ & Kompression',
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => onRemove(entry.key),
                  child: const Icon(
                    Icons.remove_circle_outline,
                    color: Color(0xFFFF453A),
                    size: 22,
                  ),
                ),
              ],
            ),
          );
        }),
        FormAddButton(label: 'Leistung hinzufügen', onTap: onAdd),
      ],
    );
  }
}
