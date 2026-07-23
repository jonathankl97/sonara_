import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/features/profile/presentation/user_provider.dart';
import 'package:sonara/shared/widgets/empty_state.dart';
import 'package:sonara/shared/widgets/section_title.dart';
import 'package:sonara/shared/enums/genres.dart';
import 'package:sonara/core/theme/app_theme.dart';

class GenreSection extends ConsumerWidget {
  const GenreSection({super.key});

  void _editGenres(BuildContext context, WidgetRef ref, List<String> current) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _GenreBottomSheet(
        current: current,
        onSave: (selected) {
          ref.read(userProvider.notifier).updateGenres(selected);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genres = ref.watch(
      userProvider.select((async) => async.value?.genres ?? []),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          (genres.isNotEmpty)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: SectionTitle('Meine Genres'),
                    ),
                    GestureDetector(
                      onTap: () => _editGenres(context, ref, genres),
                      child: const Text(
                        'Bearbeiten',
                        style: TextStyle(
                          fontSize: 13,
                          color: kAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              : const SectionTitle('Meine Genres'),

          const SizedBox(height: 12),
          if (genres.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: genres.map((g) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: kAccent.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    g,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                );
              }).toList(),
            )
          else
            EmptyState(
              icon: Icons.music_note_rounded,
              text: 'Noch keine Genres hinzugefügt',
              cta: '+ Genres hinzufügen',
              onTap: () {
                _editGenres(context, ref, genres);
              },
            ),
        ],
      ),
    );
  }
}

class _GenreBottomSheet extends StatefulWidget {
  final List<String> current;
  final ValueChanged<List<String>> onSave;

  const _GenreBottomSheet({required this.current, required this.onSave});

  @override
  State<_GenreBottomSheet> createState() => _GenreBottomSheetState();
}

class _GenreBottomSheetState extends State<_GenreBottomSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.current);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Genres bearbeiten',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: genres.map((g) {
              final isSelected = _selected.contains(g);
              return GestureDetector(
                onTap: () => setState(() {
                  if (isSelected) {
                    _selected.remove(g);
                  } else {
                    _selected.add(g);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
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
                    g,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? kAccent : Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => widget.onSave(_selected.toList()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Speichern',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
