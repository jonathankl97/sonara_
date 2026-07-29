import 'package:flutter/material.dart';
import 'package:sonara/shared/widgets/section_title.dart';
import '../../../../shared/widgets/form_helpers.dart';

class AddOnEntry {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
  }
}

class AddOnsSection extends StatelessWidget {
  final List<AddOnEntry> entries;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const AddOnsSection({
    super.key,
    required this.entries,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Add-ons'),
        const SizedBox(height: 8),
        const Text(
          'Optionale Leistungen die Kunden extra dazu buchen können.',
          style: TextStyle(fontSize: 13, color: Color(0x66FFFFFF)),
        ),
        const SizedBox(height: 12),
        ...entries.asMap().entries.map((entry) {
          return _AddOnCard(
            addon: entry.value,
            index: entry.key,
            onRemove: () => onRemove(entry.key),
          );
        }),
        FormAddButton(label: 'Extra hinzufügen', onTap: onAdd),
      ],
    );
  }
}

class _AddOnCard extends StatelessWidget {
  final AddOnEntry addon;
  final int index;
  final VoidCallback onRemove;

  const _AddOnCard({
    required this.addon,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
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
                  'Extra ${index + 1}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.remove_circle_outline,
                  color: Color(0xFFFF453A),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FormTextField(
            controller: addon.titleController,
            hint: 'z.B. Express-Lieferung',
          ),
          const SizedBox(height: 10),
          FormTextField(
            controller: addon.descriptionController,
            hint: 'Beschreibung...',
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          FormTextField(
            controller: addon.priceController,
            hint: 'Preis (€)',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
