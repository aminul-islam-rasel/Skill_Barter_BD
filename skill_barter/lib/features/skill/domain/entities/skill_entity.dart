enum SkillLevel { beginner, intermediate, expert }

class SkillEntity {
  final String id;
  final String userId;
  final String name;
  final String category;
  final String description;
  final SkillLevel level;
  final int creditPerHour;
  final List<String> availabilitySlots;
  final bool isTeaching;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SkillEntity({
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
    required this.updatedAt,
  });

  SkillEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? category,
    String? description,
    SkillLevel? level,
    int? creditPerHour,
    List<String>? availabilitySlots,
    bool? isTeaching,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SkillEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      level: level ?? this.level,
      creditPerHour: creditPerHour ?? this.creditPerHour,
      availabilitySlots: availabilitySlots ?? this.availabilitySlots,
      isTeaching: isTeaching ?? this.isTeaching,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'category': category,
      'description': description,
      'level': level.name,
      'creditPerHour': creditPerHour,
      'availabilitySlots': availabilitySlots,
      'isTeaching': isTeaching,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SkillEntity.fromMap(Map<String, dynamic> map) {
    return SkillEntity(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      level: SkillLevel.values.firstWhere(
        (e) => e.name == map['level'],
        orElse: () => SkillLevel.beginner,
      ),
      creditPerHour: map['creditPerHour'] as int,
      availabilitySlots: List<String>.from(map['availabilitySlots'] ?? []),
      isTeaching: map['isTeaching'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
