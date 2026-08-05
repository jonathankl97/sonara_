import 'package:flutter/material.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/discovery/data/models/provider_detail_model.dart';

class ProviderProfileHeader extends StatelessWidget {
  final ProviderDetailModel provider;
  final bool isLiked;
  final VoidCallback onLikeToggle;

  const ProviderProfileHeader({
    super.key,
    required this.provider,
    required this.isLiked,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profilbild + Like
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: const Color(0xFF2A2A2A),
              backgroundImage: provider.profileImageUrl != null
                  ? NetworkImage(provider.profileImageUrl!)
                  : null,
              child: provider.profileImageUrl == null
                  ? const Icon(Icons.person, color: Color(0x66FFFFFF), size: 40)
                  : null,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: onLikeToggle,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0x1AFFFFFF)),
                  ),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? kAccent : Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Name
        Text(
          provider.displayName ?? 'Provider',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        // Rollen (z.B. "Produzent, Mixing Engineer")
        if (provider.roles.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            provider.rolesLabel,
            style: const TextStyle(fontSize: 14, color: Color(0x99FFFFFF)),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 12),
        // Rating + Stadt
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: kAccent, size: 18),
            const SizedBox(width: 4),
            Text(
              provider.ratingAverage.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              ' (${provider.ratingCount})',
              style: const TextStyle(fontSize: 13, color: Color(0x66FFFFFF)),
            ),
            if (provider.city != null) ...[
              const SizedBox(width: 16),
              const Icon(
                Icons.location_on_outlined,
                color: Color(0x99FFFFFF),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                provider.city!,
                style: const TextStyle(fontSize: 14, color: Color(0x99FFFFFF)),
              ),
            ],
          ],
        ),
        // Bio
        if (provider.bio != null) ...[
          const SizedBox(height: 16),
          Text(
            provider.bio!,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xCCFFFFFF),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
