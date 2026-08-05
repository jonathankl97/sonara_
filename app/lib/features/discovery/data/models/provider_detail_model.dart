import 'package:sonara/features/discovery/data/models/service_detail_model.dart';
import 'package:sonara/features/profile/data/music_track_model.dart';
import 'package:sonara/shared/models/social_media_model.dart';

class ProviderDetailModel {
  final String id;
  final String? displayName;
  final String? city;
  final String? address;
  final String? zip;
  final String? profileImageUrl;
  final String? bio;
  final double ratingAverage;
  final int ratingCount;
  final List<String> roles;
  final List<String> genres;
  final SocialMediaModel? socialMedia;
  final List<MusicTrackModel> musicTracks;
  final List<ServiceDetailModel> services;
  final DateTime? createdAt;
  const ProviderDetailModel({
    required this.id,
    this.displayName,
    this.city,
    this.address,
    this.zip,
    this.profileImageUrl,
    this.bio,
    this.ratingAverage = 0,
    this.ratingCount = 0,
    this.roles = const [],
    this.genres = const [],
    this.socialMedia,
    this.musicTracks = const [],
    this.services = const [],
    this.createdAt,
  });

  factory ProviderDetailModel.fromJson(Map<String, dynamic> json) {
    return ProviderDetailModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      zip: json['zip'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0,
      ratingCount: json['ratingCount'] as int? ?? 0,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((r) => r as String)
              .toList() ??
          [],
      genres: (json['genres'] as List<dynamic>?)
              ?.map((g) => g as String)
              .toList() ??
          [],
      socialMedia: json['socialMedia'] != null
          ? SocialMediaModel.fromJson(
              json['socialMedia'] as Map<String, dynamic>)
          : null,
      musicTracks: (json['musicTracks'] as List<dynamic>?)
              ?.map((t) =>
                  MusicTrackModel.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      services: (json['services'] as List<dynamic>?)
              ?.map((s) =>
                  ServiceDetailModel.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  String get rolesLabel => roles.join(', ');
}