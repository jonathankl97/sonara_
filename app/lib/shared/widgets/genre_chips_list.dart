import 'package:flutter/material.dart';
import 'package:sonara/shared/enums/genres.dart';
import 'package:sonara/core/theme/app_theme.dart';

class GenreChipsList extends StatefulWidget {
  final void Function(String) onToggle;

  const GenreChipsList({super.key, required this.onToggle});

  @override
  State<GenreChipsList> createState() => _GenreChipsListState();
}

class _GenreChipsListState extends State<GenreChipsList> {
  final Set<String> _selected;

  _GenreChipsListState() : _selected = {};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: genres.map((tag) {
        final isSelected = _selected.contains(tag);
        return GestureDetector(
          onTap: () => setState(() {
            if (isSelected) {
              _selected.remove(tag);
            } else {
              _selected.add(tag);
            }
          }),
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
