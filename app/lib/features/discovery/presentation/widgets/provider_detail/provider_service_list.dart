import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/discovery/data/models/service_detail_model.dart';
import 'package:sonara/features/discovery/presentation/widgets/booking_badge.dart';
import 'package:sonara/shared/enums/booking_mode.dart';

class ProviderServiceList extends StatelessWidget {
  final List<ServiceDetailModel> services;

  const ProviderServiceList({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...services.map((service) => _ServiceCard(service: service)),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceDetailModel service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titel + Preis
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  service.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                service.priceLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: kAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Beschreibung
          if (service.description != null) ...[
            Text(
              service.description!,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0x99FFFFFF),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
          ],
          // Tags: Ort + Revisionen + Booking
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildTag(service.locationLabel),
              if (service.revisionsOffered)
                _buildTag(
                  service.revisionCount != null
                      ? '${service.revisionCount} Revisionen'
                      : 'Revisionen inkl.',
                ),
              BookingBadge(
                backgroundColor:
                    (service.bookingMode ==
                        BookingMode.weeklyAvailability.value)
                    ? const Color.fromRGBO(66, 255, 98, 0.26)
                    : kAccent.withValues(alpha: 0.26),
                sofortBuchbar:
                    BookingMode.fromValue(service.bookingMode) ==
                    BookingMode.weeklyAvailability,
              ),
            ],
          ),
          // Genres
          if (service.genres.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: service.genres.map((genre) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: kAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    genre,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: kAccent,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xCCFFFFFF),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
