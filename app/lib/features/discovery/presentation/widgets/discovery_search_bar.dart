import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';

class DiscoverySearchBar extends StatelessWidget {
  final VoidCallback onFilterTap;
  final bool hasActiveFilters;

  const DiscoverySearchBar({
    super.key,
    required this.onFilterTap,
    this.hasActiveFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Suchfeld (vorerst nur visuell — echte Textsuche kommt spaeter)
          Expanded(
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(23),
                border: Border.all(color: const Color(0x1AFFFFFF)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0x66FFFFFF), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: const Text(
                      'Suche nach Studios, Produzenten, ...',
                      style: TextStyle(color: Color(0x33FFFFFF), fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Filter-Button
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasActiveFilters ? kAccent : const Color(0x1AFFFFFF),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.tune,
                    color: hasActiveFilters ? kAccent : Colors.white,
                    size: 20,
                  ),
                  if (hasActiveFilters)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: kAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
