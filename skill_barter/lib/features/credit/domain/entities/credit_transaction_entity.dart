enum TransactionStatus { pending, completed, failed, cancelled }

class CreditTransactionEntity {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String? sessionId;
  final int amount;
  final TransactionStatus status;
  final String description;
  final DateTime timestamp;

  const CreditTransactionEntity({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    this.sessionId,
    required this.amount,
    required this.status,
    required this.description,
    required this.timestamp,
  });

  CreditTransactionEntity copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    String? sessionId,
    int? amount,
    TransactionStatus? status,
    String? description,
    DateTime? timestamp,
  }) {
    return CreditTransactionEntity(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      sessionId: sessionId ?? this.sessionId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'sessionId': sessionId,
      'amount': amount,
      'status': status.name,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CreditTransactionEntity.fromMap(Map<String, dynamic> map) {
    return CreditTransactionEntity(
      id: map['id'] as String,
      fromUserId: map['fromUserId'] as String,
      toUserId: map['toUserId'] as String,
      sessionId: map['sessionId'] as String?,
      amount: map['amount'] as int,
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TransactionStatus.pending,
      ),
      description: map['description'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
