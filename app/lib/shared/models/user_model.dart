import 'package:sonara/features/profile/data/music_track_model.dart';
import '../../features/profile/data/review_model.dart';

class UserModel {
  final String id;
  final String email;

  final String? displayName;
  final String? bio;

  final String? city;
  final String? address;
  final String? zip;

  final String? profileImageUrl;

  final String role;

  final List<String> roles;
  final List<String> genres;

  final Map<String, String> socialMedia;

  final double ratingAverage;
  final int ratingCount;

  final List<ReviewModel> receivedReviews;
  final List<MusicTrackModel> musicTracks;

  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,

    this.displayName,
    this.bio,

    this.city,
    this.address,
    this.zip,

    this.profileImageUrl,

    required this.role,

    this.roles = const [],
    this.genres = const [],

    this.socialMedia = const {},

    this.ratingAverage = 0,
    this.ratingCount = 0,

    this.receivedReviews = const [],
    this.musicTracks = const [],

    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,

      email: json['email'] as String,

      displayName: json['displayName'] as String?,
      bio: json['bio'] as String?,

      city: json['city'] as String?,
      address: json['address'] as String?,
      zip: json['zip'] as String?,

      profileImageUrl: json['profileImageUrl'] as String?,

      role: json['role'] as String,

      roles:
          (json['roles'] as List<dynamic>?)?.map((r) => r as String).toList() ??
          [],

      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((g) => g as String)
              .toList() ??
          [],

      socialMedia:
          (json['socialMedia'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as String),
          ) ??
          {},

      ratingAverage: (json['ratingAverage'] ?? 0).toDouble(),

      ratingCount: json['ratingCount'] ?? 0,

      receivedReviews:
          (json['receivedReviews'] as List<dynamic>?)
              ?.map((r) => ReviewModel.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],

      musicTracks:
          (json['musicTracks'] as List<dynamic>?)
              ?.map((t) => MusicTrackModel.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],

      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toPatchJson() {
    return {
      if (displayName != null) 'displayName': displayName,
      if (bio != null) 'bio': bio,
      if (city != null) 'city': city,
      if (address != null) 'address': address,
      if (zip != null) 'zip': zip,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'role': role,
      'roles': roles,
      'genres': genres,
      'socialMedia': socialMedia,
    };
  }

  UserModel copyWith({
    String? displayName,
    String? bio,
    String? city,
    String? address,
    String? zip,
    String? profileImageUrl,
    String? role,
    List<String>? roles,
    List<String>? genres,
    Map<String, String>? socialMedia,
    double? ratingAverage,
    int? ratingCount,
    List<ReviewModel>? receivedReviews,
    List<MusicTrackModel>? musicTracks,
  }) {
    return UserModel(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      address: address ?? this.address,
      zip: zip ?? this.zip,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      roles: roles ?? this.roles,
      genres: genres ?? this.genres,
      socialMedia: socialMedia ?? this.socialMedia,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      ratingCount: ratingCount ?? this.ratingCount,
      receivedReviews: receivedReviews ?? this.receivedReviews,
      musicTracks: musicTracks ?? this.musicTracks,
      createdAt: createdAt,
    );
  }
}
