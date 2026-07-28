import 'package:flutter/material.dart';
import 'package:sonara/shared/widgets/section_title.dart';
import 'package:sonara/features/services/presentation/widgets/form_helpers.dart';

class RoomLocationSection extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController zipController;
  final TextEditingController stateController;
  final TextEditingController countryController;

  const RoomLocationSection({
    super.key,
    required this.addressController,
    required this.cityController,
    required this.zipController,
    required this.stateController,
    required this.countryController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Standort'),
        const SizedBox(height: 20),
        const FormLabel('Adresse*'),
        const SizedBox(height: 8),
        FormTextField(
          controller: addressController,
          hint: 'Musterstraße 13',
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Bitte Adresse eingeben' : null,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel('Stadt*'),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: cityController,
                    hint: 'Berlin',
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Pflichtfeld'
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel('PLZ*'),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: zipController,
                    hint: '14169',
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Pflichtfeld'
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const FormLabel('Bundesland*'),
        const SizedBox(height: 8),
        FormTextField(
          controller: stateController,
          hint: 'Berlin',
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 16),
        const FormLabel('Land*'),
        const SizedBox(height: 8),
        FormTextField(
          controller: countryController,
          hint: 'Deutschland',
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Pflichtfeld' : null,
        ),
      ],
    );
  }
}