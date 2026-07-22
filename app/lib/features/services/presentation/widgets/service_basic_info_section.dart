import 'package:flutter/material.dart';
import 'package:sonara/features/profile/shared/section_title.dart';
import 'form_helpers.dart';

class ServiceBasicInfoSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const ServiceBasicInfoSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Basisinformation'),
        const SizedBox(height: 20),
        const FormLabel('Service-Titel*'),
        const SizedBox(height: 8),
        FormTextField(
          controller: titleController,
          hint: 'z.B. Professionelles Mixing',
          maxLength: 120,
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Bitte einen Titel eingeben'
              : null,
        ),
        const SizedBox(height: 20),
        const FormLabel('Beschreibung*'),
        const SizedBox(height: 8),
        FormTextField(
          controller: descriptionController,
          hint: 'Beschreibe deinen Service...',
          maxLines: 4,
          maxLength: 500,
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Bitte eine Beschreibung eingeben'
              : null,
        ),
      ],
    );
  }
}
