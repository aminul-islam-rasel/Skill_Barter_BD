import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/skill/domain/entities/skill_entity.dart';

/// Smart Match Logic for skill recommendations
///
/// Matches users based on:
/// 1. Skill compatibility (matching learn/teach)
/// 2. Location proximity
/// 3. Availability overlap
/// 4. Credit balance
/// 5. Rating/Trust score
class SmartMatchService {
  /// Calculate match score between a skill teacher and learner
  /// Returns a score between 0-100
  static double calculateMatchScore({
    required UserEntity teacher,
    required UserEntity learner,
    required SkillEntity teacherSkill,
    required SkillEntity learnerWant,
    required Map<String, List<String>> teacherAvailability,
    required Map<String, List<String>> learnerAvailability,
  }) {
    double score = 0;

    // 1. Skill match (0-30 points)
    final skillMatch = _calculateSkillMatch(teacherSkill, learnerWant);
    score += skillMatch * 30;

    // 2. Location proximity (0-25 points)
    final locationScore = _calculateLocationScore(
      teacher.location ?? '',
      learner.location ?? '',
    );
    score += locationScore * 25;

    // 3. Availability overlap (0-20 points)
    final availabilityScore = _calculateAvailabilityScore(
      teacherAvailability,
      learnerAvailability,
    );
    score += availabilityScore * 20;

    // 4. Credit balance compatibility (0-10 points)
    final creditScore = _calculateCreditScore(
      teacher.creditBalance,
      teacherSkill.creditPerHour,
    );
    score += creditScore * 10;

    // 5. Rating/Trust score (0-15 points)
    final trustScore = _calculateTrustScore(
      teacher.ratingAverage,
      teacher.trustScore,
    );
    score += trustScore * 15;

    return score.clamp(0, 100);
  }

  /// Rank and filter potential matches
  static List<UserMatch> rankMatches({
    required List<UserEntity> teachers,
    required SkillEntity targetSkill,
    required String learnerId,
    required Map<String, List<String>> learnerAvailability,
    required int minCredits,
  }) {
    final matches = <UserMatch>[];

    for (final teacher in teachers) {
      // Skip self
      if (teacher.id == learnerId) continue;

      // Check credit balance
      if (teacher.creditBalance < minCredits) continue;

      matches.add(
        UserMatch(
          user: teacher,
          matchScore: teacher.ratingAverage * 20, // Simplified
          matchedSkill: targetSkill.name,
        ),
      );
    }

    // Sort by match score descending
    matches.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    return matches;
  }

  /// Calculate skill match score
  static double _calculateSkillMatch(
    SkillEntity teacherSkill,
    SkillEntity learnerWant,
  ) {
    double score = 0;

    // Same category
    if (teacherSkill.category == learnerWant.category) {
      score += 0.5;
    }

    // Skill level compatibility
    final levelOrder = ['beginner', 'intermediate', 'expert'];
    final teacherLevel = levelOrder.indexOf(teacherSkill.level.name);
    final wantLevel = levelOrder.indexOf(learnerWant.level.name);

    if (teacherLevel >= wantLevel) {
      score += 0.5;
    }

    return score;
  }

  /// Calculate location proximity score
  static double _calculateLocationScore(
    String teacherLocation,
    String learnerLocation,
  ) {
    if (teacherLocation.isEmpty || learnerLocation.isEmpty) {
      return 0.5;
    }

    if (teacherLocation.toLowerCase() == learnerLocation.toLowerCase()) {
      return 1.0;
    }

    return 0.3;
  }

  /// Calculate availability overlap score
  static double _calculateAvailabilityScore(
    Map<String, List<String>> teacherAvailability,
    Map<String, List<String>> learnerAvailability,
  ) {
    if (teacherAvailability.isEmpty || learnerAvailability.isEmpty) {
      return 0.5;
    }

    int overlapDays = 0;
    final days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    for (final day in days) {
      final teacherSlots = teacherAvailability[day] ?? [];
      final learnerSlots = learnerAvailability[day] ?? [];

      if (teacherSlots.isNotEmpty && learnerSlots.isNotEmpty) {
        overlapDays++;
      }
    }

    return overlapDays / 7.0;
  }

  /// Calculate credit balance compatibility score
  static double _calculateCreditScore(int creditBalance, int creditRate) {
    if (creditRate == 0) return 0.5;

    final sessionsAffordable = creditBalance / creditRate;

    if (sessionsAffordable >= 1) return 1.0;
    if (sessionsAffordable >= 0.5) return 0.5;

    return 0.2;
  }

  /// Calculate trust score
  static double _calculateTrustScore(double ratingAverage, double trustScore) {
    final combinedScore =
        (ratingAverage / 5.0) * 0.5 + (trustScore / 100.0) * 0.5;
    return combinedScore;
  }
}

/// User match result
class UserMatch {
  final UserEntity user;
  final double matchScore;
  final String matchedSkill;

  UserMatch({
    required this.user,
    required this.matchScore,
    required this.matchedSkill,
  });
}
