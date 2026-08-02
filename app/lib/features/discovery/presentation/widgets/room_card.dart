import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/discovery/data/models/room_search_result.dart';
import 'package:sonara/features/discovery/presentation/widgets/booking_badge.dart';
import 'package:sonara/shared/enums/booking_mode.dart';

class RoomCard extends StatelessWidget {
  final RoomSearchResult room;
  final VoidCallback? onTap;

  const RoomCard({super.key, required this.room, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Bild-Container mit Overlays ──
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Room-Bild
                    room.firstImageUrl.isNotEmpty
                        ? Image.network(
                            room.firstImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _placeholder(),
                          )
                        : _placeholder(),
                    // Booking-Badge (links unten)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: BookingBadge(
                        sofortBuchbar:
                            room.bookingMode == BookingMode.weeklyAvailability,
                      ),
                    ),
                    // Stadt (rechts unten)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Text(
                        room.city,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Favorit-Icon (rechts oben)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ── Text-Infos darunter ──
            const SizedBox(height: 10),
            // Name
            Text(
              room.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Raumtyp
            Text(
              room.roomTypeLabel,
              style: const TextStyle(fontSize: 13, color: Color(0x99FFFFFF)),
            ),
            const SizedBox(height: 6),
            // Rating + Preis
            Row(
              children: [
                const Icon(Icons.star, color: kAccent, size: 14),
                const SizedBox(width: 3),
                const Text(
                  '4,6',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  room.priceLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0x99FFFFFF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFF2A2A2A),
      child: const Center(
        child: Icon(Icons.image, color: Color(0x33FFFFFF), size: 40),
      ),
    );
  }
}
