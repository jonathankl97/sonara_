import 'package:flutter/material.dart';
import 'package:sonara/shared/widgets/section_title.dart';
import 'package:sonara/features/rooms/data/enums/room_enums.dart';
import 'package:sonara/features/services/presentation/widgets/form_helpers.dart';

const _priceModelLabels = {
  RoomPriceModel.hourly: 'Stundenpreis',
  RoomPriceModel.perDay: 'Tagespreis',
};

const _priceModelDescriptions = {
  RoomPriceModel.hourly: 'Abrechnung pro Stunde Nutzung.',
  RoomPriceModel.perDay: 'Abrechnung pro Tag.',
};

class RoomPricingSection extends StatelessWidget {
  final RoomPriceModel selectedModel;
  final ValueChanged<RoomPriceModel?> onModelChanged;
  final TextEditingController priceController;

  const RoomPricingSection({
    super.key,
    required this.selectedModel,
    required this.onModelChanged,
    required this.priceController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Preise'),
        const SizedBox(height: 12),
        const FormLabel('Preismodell*'),
        const SizedBox(height: 8),
        FormDropdown<RoomPriceModel>(
          value: selectedModel,
          items: RoomPriceModel.values,
          labels: _priceModelLabels,
          onChanged: onModelChanged,
        ),
        const SizedBox(height: 8),
        Text(
          _priceModelDescriptions[selectedModel] ?? '',
          style: const TextStyle(fontSize: 13, color: Color(0x66FFFFFF)),
        ),
        const SizedBox(height: 20),
        const FormLabel('Basispreis (€)*'),
        const SizedBox(height: 8),
        FormTextField(
          controller: priceController,
          hint: 'z.B. 60',
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Preis eingeben';
            final price = double.tryParse(v);
            if (price == null || price < 0) return 'Gültigen Preis eingeben';
            return null;
          },
        ),
      ],
    );
  }
}
