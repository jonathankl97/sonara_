import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/shared/widgets/section_title.dart';
import '../../../../shared/widgets/form_helpers.dart';

class RevisionsSection extends StatelessWidget {
  final bool offersRevisions;
  final ValueChanged<bool> onChanged;
  final TextEditingController countController;

  const RevisionsSection({
    super.key,
    required this.offersRevisions,
    required this.onChanged,
    required this.countController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Revisionen'),
        const SizedBox(height: 12),
        Row(
          children: [
            Checkbox(
              activeColor: kAccent,
              value: offersRevisions,
              onChanged: (v) => onChanged(v ?? false),
            ),
            const SizedBox(width: 8),
            const Text(
              'Ich biete Revisionen an',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (offersRevisions) ...[
          const SizedBox(height: 12),
          const FormLabel('Anzahl'),
          const SizedBox(height: 8),
          FormTextField(
            controller: countController,
            hint: 'z.B. 2',
            keyboardType: TextInputType.number,
            validator: (v) {
              if (!offersRevisions) return null;
              if (v == null || v.isEmpty) return 'Anzahl eingeben';
              if (int.tryParse(v) == null) return 'Gültige Zahl eingeben';
              return null;
            },
          ),
        ],
      ],
    );
  }
}
