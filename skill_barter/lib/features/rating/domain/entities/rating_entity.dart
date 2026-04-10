class RatingEntity {
  final String id;
  final String sessionId;
  final String fromUserId;
  final String toUserId;
  final int rating; // 1-5
  final String? comment;
  final DateTime createdAt;

  const RatingEntity({
    required this.id,
    required this.sessionId,
    required this.fromUserId,
    required this.toUserId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  RatingEntity copyWith({
    String? id,
    String? sessionId,
    String? fromUserId,
    String? toUserId,
    int? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return RatingEntity(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sessionId': sessionId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RatingEntity.fromMap(Map<String, dynamic> map) {
    return RatingEntity(
      id: map['id'] as String,
      sessionId: map['sessionId'] as String,
      fromUserId: map['fromUserId'] as String,
      toUserId: map['toUserId'] as String,
      rating: map['rating'] as int,
      comment: map['comment'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

/// Trust score calculation utility
class TrustScoreCalculator {
  /// Calculate trust score based on multiple factors
  /// Formula: (rating * 0.4) + (completionRate * 0.3) + (totalSessions * 0.1 max) + (verifiedBadge * 0.2)
  /// Returns a score between 0-100
  static double calculateTrustScore({
    required double averageRating,
    required double completionRate,
    required int totalSessions,
    required bool isVerified,
  }) {
    // Rating component (0-40 points)
    final ratingComponent = (averageRating / 5.0) * 40;

    // Completion rate component (0-30 points)
    final completionComponent = completionRate * 30;

    // Session experience component (0-10 points, max at 100 sessions)
    final sessionComponent = (totalSessions.clamp(0, 100) / 100.0) * 10;

    // Verified badge component (0-20 points)
    final verifiedComponent = isVerified ? 20.0 : 0.0;

    return ratingComponent +
        completionComponent +
        sessionComponent +
        verifiedComponent;
  }
}
