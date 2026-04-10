enum SessionStatus { pending, confirmed, completed, cancelled }

class SessionEntity {
  final String id;
  final String teacherId;
  final String learnerId;
  final String skillId;
  final DateTime scheduledTime;
  final int duration; // in minutes
  final int creditAmount;
  final SessionStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SessionEntity({
    required this.id,
    required this.teacherId,
    required this.learnerId,
    required this.skillId,
    required this.scheduledTime,
    required this.duration,
    required this.creditAmount,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  SessionEntity copyWith({
    String? id,
    String? teacherId,
    String? learnerId,
    String? skillId,
    DateTime? scheduledTime,
    int? duration,
    int? creditAmount,
    SessionStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SessionEntity(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      learnerId: learnerId ?? this.learnerId,
      skillId: skillId ?? this.skillId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      duration: duration ?? this.duration,
      creditAmount: creditAmount ?? this.creditAmount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teacherId': teacherId,
      'learnerId': learnerId,
      'skillId': skillId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'duration': duration,
      'creditAmount': creditAmount,
      'status': status.name,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SessionEntity.fromMap(Map<String, dynamic> map) {
    return SessionEntity(
      id: map['id'] as String,
      teacherId: map['teacherId'] as String,
      learnerId: map['learnerId'] as String,
      skillId: map['skillId'] as String,
      scheduledTime: DateTime.parse(map['scheduledTime'] as String),
      duration: map['duration'] as int,
      creditAmount: map['creditAmount'] as int,
      status: SessionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SessionStatus.pending,
      ),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
