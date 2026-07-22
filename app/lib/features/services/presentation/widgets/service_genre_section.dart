import 'package:flutter/material.dart';
import 'package:sonara/features/profile/shared/section_title.dart';
import 'package:sonara/shared/widgets/genre_chips_list.dart';

class ServiceGenresSection extends StatelessWidget {
  final ValueChanged<List<String>> onChanged;

  const ServiceGenresSection({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Genres'),
        const SizedBox(height: 8),
        const Text(
          'Wähle alle Genres aus, auf die du spezialisiert bist.',
          style: TextStyle(fontSize: 13, color: Color(0x66FFFFFF)),
        ),
        const SizedBox(height: 12),
        GenreChipsList(onChanged: onChanged),
      ],
    );
  }
}
