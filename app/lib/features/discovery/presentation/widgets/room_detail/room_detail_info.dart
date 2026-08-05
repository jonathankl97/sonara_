import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/shared/widgets/section_title.dart';

class RoomDetailInfo extends StatelessWidget {
  final String description;
  final int? sizeSqm;
  final int? capacity;
  final String fullAddress;
  final List<String> amenities;

  const RoomDetailInfo({
    super.key,
    required this.description,
    this.sizeSqm,
    this.capacity,
    required this.fullAddress,
    this.amenities = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Beschreibung ──
        SectionTitle('Über diesen Raum'),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xCCFFFFFF),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // ── Details (Groesse, Kapazitaet) ──
        if (sizeSqm != null || capacity != null) ...[
          SectionTitle('Details'),
          const SizedBox(height: 12),
          Row(
            children: [
              if (sizeSqm != null)
                _buildDetailChip(Icons.square_foot, '$sizeSqm m²'),
              if (sizeSqm != null && capacity != null)
                const SizedBox(width: 12),
              if (capacity != null)
                _buildDetailChip(Icons.people_outline, '$capacity Personen'),
            ],
          ),
          const SizedBox(height: 24),
        ],

        // ── Standort ──
        SectionTitle('Standort'),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, color: kAccent, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                fullAddress,
                style: const TextStyle(fontSize: 14, color: Color(0xCCFFFFFF)),
              ),
            ),
          ],
        ),

        // ── Ausstattung ──
        if (amenities.isNotEmpty) ...[
          const SizedBox(height: 24),
          SectionTitle('Ausstattung'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: amenities.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0x1AFFFFFF)),
                ),
                child: Text(
                  amenity,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: kAccent, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
