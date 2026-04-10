class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? profilePhoto;
  final String location;
  final String bio;
  final int creditBalance;
  final double trustScore;
  final double ratingAverage;
  final int totalSessions;
  final DateTime createdAt;
  final bool isAdmin;
  final bool isSuspended;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.profilePhoto,
    required this.location,
    required this.bio,
    required this.creditBalance,
    required this.trustScore,
    required this.ratingAverage,
    required this.totalSessions,
    required this.createdAt,
    this.isAdmin = false,
    this.isSuspended = false,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePhoto,
    String? location,
    String? bio,
    int? creditBalance,
    double? trustScore,
    double? ratingAverage,
    int? totalSessions,
    DateTime? createdAt,
    bool? isAdmin,
    bool? isSuspended,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      creditBalance: creditBalance ?? this.creditBalance,
      trustScore: trustScore ?? this.trustScore,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      totalSessions: totalSessions ?? this.totalSessions,
      createdAt: createdAt ?? this.createdAt,
      isAdmin: isAdmin ?? this.isAdmin,
      isSuspended: isSuspended ?? this.isSuspended,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
