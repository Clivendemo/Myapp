class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final bool isPremium;
  final int generatedPlansCount;
  final DateTime registeredAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.isPremium = false,
    this.generatedPlansCount = 0,
    required this.registeredAt,
  });

  // Create a copy with updated values
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    bool? isPremium,
    int? generatedPlansCount,
    DateTime? registeredAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isPremium: isPremium ?? this.isPremium,
      generatedPlansCount: generatedPlansCount ?? this.generatedPlansCount,
      registeredAt: registeredAt ?? this.registeredAt,
    );
  }

  // Helper methods
  bool get canGenerateFreePlan => generatedPlansCount < 3;
  bool get hasActivePremium => isPremium;
}
