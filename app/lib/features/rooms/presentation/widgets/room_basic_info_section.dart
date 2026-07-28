import 'package:flutter/material.dart';
import 'package:sonara/features/rooms/data/enums/room_enums.dart';
import 'package:sonara/features/services/presentation/widgets/form_helpers.dart';
import 'package:sonara/shared/widgets/section_title.dart';

class RoomBasicInfoSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final RoomType selectedRoomType;
  final ValueChanged<RoomType?> onTypeChanged;

  const RoomBasicInfoSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedRoomType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Basisinformation'),
        const SizedBox(height: 20),
        const FormLabel('Name des Mietobjekts*'),
        const SizedBox(height: 8),
        FormTextField(
          controller: titleController,
          hint: 'z.B. Studio Sonara',
          maxLength: 120,
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Bitte einen Namen eingeben'
              : null,
        ),
        const SizedBox(height: 20),
        FormDropdown<RoomType>(
          value: selectedRoomType,
          items: RoomType.values,
          labels: roomTypeLabels,
          onChanged: onTypeChanged,
        ),
        const SizedBox(height: 20,),
        const FormLabel('Beschreibung*'),
        const SizedBox(height: 8),
        FormTextField(
          controller: descriptionController,
          hint: 'Beschreibe dein Studio...',
          maxLines: 8,
          maxLength: 1000,
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Bitte eine Beschreibung eingeben'
              : null,
        ),
      ],
    );
  }
}
