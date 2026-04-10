import 'package:hive/hive.dart';

// Note: Using Hive without code generation
// For production, use hive_generator

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? profilePhoto;

  @HiveField(4)
  final String? location;

  @HiveField(5)
  final String? bio;

  @HiveField(6)
  final int creditBalance;

  @HiveField(7)
  final double trustScore;

  @HiveField(8)
  final double ratingAverage;

  @HiveField(9)
  final int totalSessions;

  @HiveField(10)
  final DateTime createdAt;

  UserHiveModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePhoto,
    this.location,
    this.bio,
    required this.creditBalance,
    required this.trustScore,
    required this.ratingAverage,
    required this.totalSessions,
    required this.createdAt,
  });
}

@HiveType(typeId: 1)
class SkillHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String level;

  @HiveField(6)
  final int creditPerHour;

  @HiveField(7)
  final List<String> availabilitySlots;

  @HiveField(8)
  final bool isTeaching;

  @HiveField(9)
  final DateTime createdAt;

  SkillHiveModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.description,
    required this.level,
    required this.creditPerHour,
    required this.availabilitySlots,
    required this.isTeaching,
    required this.createdAt,
  });
}

@HiveType(typeId: 2)
class PendingActionHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String actionType;

  @HiveField(3)
  final Map<String, dynamic> data;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final bool synced;

  PendingActionHiveModel({
    required this.id,
    required this.userId,
    required this.actionType,
    required this.data,
    required this.createdAt,
    required this.synced,
  });
}

@HiveType(typeId: 3)
class ChatHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String participantId;

  @HiveField(2)
  final String lastMessage;

  @HiveField(3)
  final DateTime lastMessageTime;

  @HiveField(4)
  final int unreadCount;

  ChatHiveModel({
    required this.id,
    required this.participantId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}
