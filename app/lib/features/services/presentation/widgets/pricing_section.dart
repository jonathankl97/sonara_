import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/shared/widgets/section_title.dart';
import 'package:sonara/features/services/data/enums/service_enums.dart';
import '../../../../shared/widgets/form_helpers.dart';

const _priceModelLabels = {
  PriceModel.fixed: 'Fixpreis',
  PriceModel.hourly: 'Stundensatz',
  PriceModel.perTrack: 'Pro Track',
  PriceModel.inquiry: 'Auf Anfrage',
};

const _priceModelDescriptions = {
  PriceModel.fixed: 'Kunden zahlen einen Festpreis für den gesamten Service.',
  PriceModel.hourly: 'Abrechnung nach der tatsächlich geleisteten Arbeitszeit.',
  PriceModel.perTrack: 'Preis pro Track oder Song.',
  PriceModel.inquiry:
      'Preis auf Anfrage — individuelles Angebot nach Absprache.',
};

class PricingSection extends StatelessWidget {
  final PriceModel selectedModel;
  final ValueChanged<PriceModel?> onModelChanged;
  final TextEditingController priceController;
  final bool allowCustomRequests;
  final ValueChanged<bool> onCustomRequestsChanged;

  const PricingSection({
    super.key,
    required this.selectedModel,
    required this.onModelChanged,
    required this.priceController,
    required this.allowCustomRequests,
    required this.onCustomRequestsChanged,
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
        FormDropdown<PriceModel>(
          value: selectedModel,
          items: PriceModel.values,
          labels: _priceModelLabels,
          onChanged: onModelChanged,
        ),
        const SizedBox(height: 8),
        Text(
          _priceModelDescriptions[selectedModel] ?? '',
          style: const TextStyle(fontSize: 13, color: Color(0x66FFFFFF)),
        ),
        if (selectedModel != PriceModel.inquiry) ...[
          const SizedBox(height: 20),
          const FormLabel('Basispreis*'),
          const SizedBox(height: 8),
          FormTextField(
            controller: priceController,
            hint: 'z.B. 150',
            keyboardType: TextInputType.number,
            validator: (v) {
              if (selectedModel == PriceModel.inquiry) return null;
              if (v == null || v.isEmpty) return 'Preis eingeben';
              final price = double.tryParse(v);
              if (price == null || price < 0) return 'Gültigen Preis eingeben';
              return null;
            },
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              activeColor: kAccent,
              value: allowCustomRequests,
              onChanged: (v) => onCustomRequestsChanged(v ?? false),
            ),
            const SizedBox(width: 8),
            const Text(
              'Individuelle Anfragen erlauben',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
