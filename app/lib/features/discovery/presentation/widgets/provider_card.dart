import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/discovery/data/models/provider_search_result.dart';

class ProviderCard extends StatelessWidget {
  final ProviderSearchResult provider;
  final VoidCallback? onTap;

  const ProviderCard({
    super.key,
    required this.provider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x1AFFFFFF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profilbild + Herz-Icon
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: const Color(0xFF2A2A2A),
                      backgroundImage: provider.profileImageUrl != null
                          ? NetworkImage(provider.profileImageUrl!)
                          : null,
                      child: provider.profileImageUrl == null
                          ? const Icon(Icons.person,
                              color: Color(0x66FFFFFF), size: 32)
                          : null,
                    ),
                  ),
                  // Favorit-Icon (Platzhalter — Feature kommt spaeter)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                provider.displayName ?? 'Provider',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            // Service-Types
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                provider.serviceTypesLabel,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0x99FFFFFF),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            // Booking-Badge + Stadt
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  _BookingBadge(
                    sofortBuchbar: provider.hasSofortBuchbar,
                  ),
                  const SizedBox(width: 6),
                  if (provider.city != null)
                    Expanded(
                      child: Text(
                        provider.city!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0x66FFFFFF),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Services-Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                provider.services.map((s) => s.title).join(', '),
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0x66FFFFFF),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            // Rating
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  const Icon(Icons.star, color: kAccent, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    provider.ratingAverage.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingBadge extends StatelessWidget {
  final bool sofortBuchbar;

  const _BookingBadge({required this.sofortBuchbar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: sofortBuchbar
            ? const Color(0xFF4CAF50).withValues(alpha: 0.2)
            : kAccent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        sofortBuchbar ? 'Sofort buchbar' : 'Auf Anfrage',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: sofortBuchbar ? const Color(0xFF4CAF50) : kAccent,
        ),
      ),
    );
  }
}
