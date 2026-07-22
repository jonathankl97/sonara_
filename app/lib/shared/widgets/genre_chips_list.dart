import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/shared/enums/genres.dart';

class GenreChipsList extends StatefulWidget {
  final ValueChanged<List<String>> onChanged;

  const GenreChipsList({super.key, required this.onChanged});

  @override
  State<GenreChipsList> createState() => _GenreChipsListState();
}

class _GenreChipsListState extends State<GenreChipsList> {
  final Set<String> _selected = {};

  void _toggle(String genre) {
    setState(() {
      if (_selected.contains(genre)) {
        _selected.remove(genre);
      } else {
        _selected.add(genre);
      }
    });

    widget.onChanged(_selected.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: genres.map((tag) {
        final isSelected = _selected.contains(tag);

        return GestureDetector(
          onTap: () => _toggle(tag),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? kAccent.withOpacity(0.15)
                  : const Color(0xFF1A1A1A),
              border: Border.all(
                color: isSelected ? kAccent : const Color(0x1AFFFFFF),
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              tag,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? kAccent : Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
