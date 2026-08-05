import 'package:flutter/material.dart';
import 'package:sonara/features/discovery/presentation/widgets/booking_badge.dart';
import 'package:sonara/shared/enums/booking_mode.dart';

class RoomDetailHeader extends StatelessWidget {
  final String name;
  final String roomTypeLabel;
  final BookingMode bookingMode;
  final double? ratingAverage;
  final int? ratingCount;
  final String? city;

  const RoomDetailHeader({
    super.key,
    required this.name,
    required this.roomTypeLabel,
    required this.bookingMode,
    this.ratingAverage,
    this.ratingCount,
    this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                roomTypeLabel,
                style: const TextStyle(fontSize: 15, color: Color(0x99FFFFFF)),
              ),
              ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (ratingAverage != null && ratingCount! >= 1) ...[
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFC107),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$ratingAverage ($ratingCount)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Icon(
                      Icons.location_on_outlined,
                      color: Color(0x99FFFFFF),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      city ?? 'Unbekannt',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0x99FFFFFF),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        BookingBadge(
          backgroundColor: Colors.black.withValues(alpha: 0.72),
          sofortBuchbar: bookingMode == BookingMode.weeklyAvailability,
        ),
      ],
    );
  }
}
