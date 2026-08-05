import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/theme/app_theme.dart';
import 'package:sonara/features/discovery/data/models/provider_detail_model.dart';
import 'package:sonara/features/discovery/data/repositories/discovery_repository.dart';
import 'package:sonara/features/profile/presentation/widgets/profile_header.dart';
import 'package:sonara/features/profile/presentation/widgets/profile_stats.dart';
import 'package:sonara/shared/widgets/section_title.dart';
import 'widgets/provider_detail/provider_social_links.dart';
import 'widgets/provider_detail/provider_service_list.dart';
import 'widgets/provider_detail/provider_music_section.dart';

final providerDetailProvider =
    FutureProvider.family<ProviderDetailModel, String>((ref, id) async {
      final repository = ref.read(discoveryRepositoryProvider);
      return repository.fetchProviderDetail(id);
    });

class ProviderDetailScreen extends ConsumerStatefulWidget {
  final String providerId;

  const ProviderDetailScreen({super.key, required this.providerId});

  @override
  ConsumerState<ProviderDetailScreen> createState() =>
      _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends ConsumerState<ProviderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(providerDetailProvider(widget.providerId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: detailAsync.whenOrNull(
          data: (provider) => Text(
            provider.displayName ?? 'Provider',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: detailAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kAccent)),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFFF453A),
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                error.toString(),
                style: const TextStyle(color: Color(0x99FFFFFF), fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                    ref.invalidate(providerDetailProvider(widget.providerId)),
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
        data: (provider) => _buildContent(provider),
      ),
    );
  }

  Widget _buildContent(ProviderDetailModel provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profil-Header (Bild, Name, Rollen, Rating, Bio)
          Center(
            child: ProfileHeader(
              profileImageUrl: provider.profileImageUrl,
              bio: provider.bio,
            ),
          ),
          ProfileStats(
            createdAt: provider.createdAt!,
            averageRating: provider.ratingAverage,
            ratingsCount: provider.ratingCount,
          ),
          const SizedBox(height: 24),

          // Genres
          if (provider.genres.isNotEmpty) ...[
            const SectionTitle('Genres'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: provider.genres.map((genre) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: kAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kAccent),
                  ),
                  child: Text(
                    genre,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kAccent,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Services
          ProviderServiceList(services: provider.services),
          if (provider.services.isNotEmpty) const SizedBox(height: 24),

          // Musik
          ProviderMusicSection(tracks: provider.musicTracks),
          if (provider.musicTracks.isNotEmpty) const SizedBox(height: 24),

          // Social Media
          if (provider.socialMedia != null)
            ProviderSocialLinks(socialMedia: provider.socialMedia!),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
