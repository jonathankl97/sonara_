class SocialMedia {
  final String? instagram;
  final String? youtube;
  final String? spotify;
  final String? tiktok;
  final String? soundcloud;
  final String? appleMusic;

  const SocialMedia({
    this.instagram,
    this.youtube,
    this.spotify,
    this.tiktok,
    this.soundcloud,
    this.appleMusic,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      instagram: json['instagram'] as String?,
      youtube: json['youtube'] as String?,
      spotify: json['spotify'] as String?,
      tiktok: json['tiktok'] as String?,
      soundcloud: json['soundcloud'] as String?,
      appleMusic: json['appleMusic'] as String?,
    );
  }

  bool get hasAny =>
      instagram != null ||
      youtube != null ||
      spotify != null ||
      tiktok != null ||
      soundcloud != null ||
      appleMusic != null;

  List<MapEntry<String, String>> get entries {
    final map = <String, String>{};
    if (instagram != null) map['Instagram'] = instagram!;
    if (youtube != null) map['YouTube'] = youtube!;
    if (spotify != null) map['Spotify'] = spotify!;
    if (tiktok != null) map['TikTok'] = tiktok!;
    if (soundcloud != null) map['SoundCloud'] = soundcloud!;
    if (appleMusic != null) map['Apple Music'] = appleMusic!;
    return map.entries.toList();
  }
}
