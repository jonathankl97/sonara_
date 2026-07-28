import 'package:flutter/material.dart';
import 'package:sonara/features/services/presentation/widgets/form_helpers.dart';

class RoomSizeSection extends StatelessWidget {
  final TextEditingController sizeSqmController;
  final TextEditingController capacityController;

  const RoomSizeSection({
    super.key,
    required this.sizeSqmController,
    required this.capacityController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormLabel('Größe (m²)'),
              const SizedBox(height: 8),
              FormTextField(
                controller: sizeSqmController,
                hint: 'z.B. 65',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormLabel('Kapazität (Personen)'),
              const SizedBox(height: 8),
              FormTextField(
                controller: capacityController,
                hint: 'z.B. 4',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
