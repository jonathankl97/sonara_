class MusicTrackModel {
  final String id;
  final String name;
  final List<String> artists;
  final String albumImage;
  final String spotifyUrl;
  final String? appleMusicUrl;

  const MusicTrackModel({
    required this.id,
    required this.name,
    required this.artists,
    required this.albumImage,
    required this.spotifyUrl,
    this.appleMusicUrl,
  });

  factory MusicTrackModel.fromJson(Map<String, dynamic> json) {
    return MusicTrackModel(
      id: json['id'] as String,
      name: json['name'] as String,
      artists: (json['artists'] as List<dynamic>)
          .map((a) => a as String)
          .toList(),
      albumImage: json['albumImage'] as String,
      spotifyUrl: json['spotifyUrl'] as String,
      appleMusicUrl: json['appleMusicUrl'] as String?,
    );
  }
}