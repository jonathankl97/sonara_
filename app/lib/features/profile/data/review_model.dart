class ReviewModel {
  final String id;
  final int rating;
  final String? comment;

  final String authorId;
  final String providerId;

  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.rating,
    this.comment,
    required this.authorId,
    required this.providerId,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,

      authorId: json['author']['id'] as String,
      providerId: json['provider']['id'] as String,

      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
    );
  }
}