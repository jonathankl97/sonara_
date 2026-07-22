import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sonara/features/profile/widgets/contact_section.dart';
import 'package:sonara/features/profile/widgets/genre_section.dart';
import 'package:sonara/features/profile/widgets/profile_complete_banner.dart';
import 'package:sonara/features/profile/widgets/profile_header.dart';
import 'package:sonara/features/profile/widgets/profile_stats.dart';
import 'package:sonara/features/profile/widgets/ratings_section.dart';
import 'package:sonara/features/profile/widgets/social_media_section.dart';
import 'package:sonara/features/profile/widgets/switch_role_banner.dart';
import 'package:sonara/features/profile/presentation/user_provider.dart';
import 'package:sonara/features/profile/widgets/edit_profile_sheet.dart';
import 'package:sonara/features/profile/widgets/music_section.dart';
import 'package:sonara/features/profile/widgets/profile_drawer.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return user.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (user) {
        if (user == null) {
          return const Center(child: Text('Kein Benutzer gefunden'));
        }

        final completeness =
            [
              user.bio != null,
              user.genres.isNotEmpty,
              user.socialMedia.isNotEmpty,
              user.profileImageUrl != null,
            ].where((v) => v).length /
            4;
        return Scaffold(
          drawer: ProfileDrawer(user: user),
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: const Color(0xFF111111),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (ctx) => const EditProfileSheet(),
                  );
                },
                child: const Text('Bearbeiten'),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileHeader(
                        profileImageUrl: user.profileImageUrl,
                        displayName: user.displayName,
                        bio: user.bio,
                      ),
                      const SizedBox(height: 16),
                      ProfileStats(
                        createdAt: user.createdAt,
                        ratingsCount: user.ratingCount,
                        averageRating: user.ratingAverage,
                      ),
                      const SizedBox(height: 16),
                      if (completeness < 1)
                        ProfileCompleteBanner(completeness: completeness),
                      const SizedBox(height: 50),
                      ContactSection(email: user.email, location: user.city),
                      GenreSection(),
                      SocialMediaSection(),
                      MusicSection(),
                      RatingsSection(),
                      if (user.role == 'artist') SwitchRoleBanner(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
