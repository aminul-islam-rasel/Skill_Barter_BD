import 'package:hive_flutter/hive_flutter.dart';
import '../local/hive_models.dart';

class HiveService {
  static const String userBoxName = 'users';
  static const String skillsBoxName = 'skills';
  static const String pendingActionsBoxName = 'pending_actions';
  static const String chatsBoxName = 'chats';
  static const String settingsBoxName = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(UserHiveModelAdapter());
    Hive.registerAdapter(SkillHiveModelAdapter());
    Hive.registerAdapter(PendingActionHiveModelAdapter());
    Hive.registerAdapter(ChatHiveModelAdapter());

    // Open boxes
    await Hive.openBox<UserHiveModel>(userBoxName);
    await Hive.openBox<SkillHiveModel>(skillsBoxName);
    await Hive.openBox<PendingActionHiveModel>(pendingActionsBoxName);
    Hive.openBox<ChatHiveModel>(chatsBoxName);
    Hive.openBox(settingsBoxName);
  }

  // User operations
  static Box<UserHiveModel> get userBox => Hive.box<UserHiveModel>(userBoxName);

  static Future<void> cacheUser(UserHiveModel user) async {
    await userBox.put(user.id, user);
  }

  static UserHiveModel? getCachedUser(String userId) {
    return userBox.get(userId);
  }

  static Future<void> clearUserCache() async {
    await userBox.clear();
  }

  // Skills operations
  static Box<SkillHiveModel> get skillsBox =>
      Hive.box<SkillHiveModel>(skillsBoxName);

  static Future<void> cacheSkills(List<SkillHiveModel> skills) async {
    for (var skill in skills) {
      await skillsBox.put(skill.id, skill);
    }
  }

  static List<SkillHiveModel> getCachedSkills({String? userId}) {
    if (userId != null) {
      return skillsBox.values.where((s) => s.userId == userId).toList();
    }
    return skillsBox.values.toList();
  }

  static Future<void> clearSkillsCache() async {
    await skillsBox.clear();
  }

  // Pending actions for offline sync
  static Box<PendingActionHiveModel> get pendingActionsBox =>
      Hive.box<PendingActionHiveModel>(pendingActionsBoxName);

  static Future<void> addPendingAction(PendingActionHiveModel action) async {
    await pendingActionsBox.put(action.id, action);
  }

  static List<PendingActionHiveModel> getPendingActions() {
    return pendingActionsBox.values.where((a) => !a.synced).toList();
  }

  static Future<void> markActionSynced(String actionId) async {
    final action = pendingActionsBox.get(actionId);
    if (action != null) {
      // Create a new updated action
      final updated = PendingActionHiveModel(
        id: action.id,
        userId: action.userId,
        actionType: action.actionType,
        data: action.data,
        createdAt: action.createdAt,
        synced: true,
      );
      await pendingActionsBox.put(actionId, updated);
    }
  }

  static Future<void> clearPendingActions() async {
    await pendingActionsBox.clear();
  }

  // Chat operations
  static Box<ChatHiveModel> get chatsBox =>
      Hive.box<ChatHiveModel>(chatsBoxName);

  static Future<void> cacheChats(List<ChatHiveModel> chats) async {
    for (var chat in chats) {
      await chatsBox.put(chat.id, chat);
    }
  }

  static List<ChatHiveModel> getCachedChats() {
    return chatsBox.values.toList();
  }

  // Settings operations
  static Box get settingsBox => Hive.box(settingsBoxName);

  static Future<void> setSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue);
  }

  // Sync strategy
  static Future<void> syncPendingActions() async {
    // Get all unsynced actions
    final pendingActions = getPendingActions();

    for (var action in pendingActions) {
      try {
        // Try to sync to server
        // This would call the appropriate remote datasource
        // For now, mark as synced (in production, actually sync)
        await markActionSynced(action.id);
      } catch (e) {
        // Keep in pending if sync fails
        print('Failed to sync action ${action.id}: $e');
      }
    }
  }
}

// Simple adapters without code generation
class UserHiveModelAdapter extends TypeAdapter<UserHiveModel> {
  @override
  final int typeId = 0;

  @override
  UserHiveModel read(BinaryReader reader) {
    return UserHiveModel(
      id: reader.read(),
      name: reader.read(),
      email: reader.read(),
      profilePhoto: reader.read(),
      location: reader.read(),
      bio: reader.read(),
      creditBalance: reader.read(),
      trustScore: reader.read(),
      ratingAverage: reader.read(),
      totalSessions: reader.read(),
      createdAt: DateTime.parse(reader.read()),
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveModel obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.email);
    writer.write(obj.profilePhoto);
    writer.write(obj.location);
    writer.write(obj.bio);
    writer.write(obj.creditBalance);
    writer.write(obj.trustScore);
    writer.write(obj.ratingAverage);
    writer.write(obj.totalSessions);
    writer.write(obj.createdAt.toIso8601String());
  }
}

class SkillHiveModelAdapter extends TypeAdapter<SkillHiveModel> {
  @override
  final int typeId = 1;

  @override
  SkillHiveModel read(BinaryReader reader) {
    return SkillHiveModel(
      id: reader.read(),
      userId: reader.read(),
      name: reader.read(),
      category: reader.read(),
      description: reader.read(),
      level: reader.read(),
      creditPerHour: reader.read(),
      availabilitySlots: (reader.read() as List).cast<String>(),
      isTeaching: reader.read(),
      createdAt: DateTime.parse(reader.read()),
    );
  }

  @override
  void write(BinaryWriter writer, SkillHiveModel obj) {
    writer.write(obj.id);
    writer.write(obj.userId);
    writer.write(obj.name);
    writer.write(obj.category);
    writer.write(obj.description);
    writer.write(obj.level);
    writer.write(obj.creditPerHour);
    writer.write(obj.availabilitySlots);
    writer.write(obj.isTeaching);
    writer.write(obj.createdAt.toIso8601String());
  }
}

class PendingActionHiveModelAdapter
    extends TypeAdapter<PendingActionHiveModel> {
  @override
  final int typeId = 2;

  @override
  PendingActionHiveModel read(BinaryReader reader) {
    return PendingActionHiveModel(
      id: reader.read(),
      userId: reader.read(),
      actionType: reader.read(),
      data: Map<String, dynamic>.from(reader.read()),
      createdAt: DateTime.parse(reader.read()),
      synced: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, PendingActionHiveModel obj) {
    writer.write(obj.id);
    writer.write(obj.userId);
    writer.write(obj.actionType);
    writer.write(obj.data);
    writer.write(obj.createdAt.toIso8601String());
    writer.write(obj.synced);
  }
}

class ChatHiveModelAdapter extends TypeAdapter<ChatHiveModel> {
  @override
  final int typeId = 3;

  @override
  ChatHiveModel read(BinaryReader reader) {
    return ChatHiveModel(
      id: reader.read(),
      participantId: reader.read(),
      lastMessage: reader.read(),
      lastMessageTime: DateTime.parse(reader.read()),
      unreadCount: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatHiveModel obj) {
    writer.write(obj.id);
    writer.write(obj.participantId);
    writer.write(obj.lastMessage);
    writer.write(obj.lastMessageTime.toIso8601String());
    writer.write(obj.unreadCount);
  }
}
