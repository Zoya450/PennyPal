class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String role;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool hasSeenTutorial;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.role,
    required this.createdAt,
    required this.lastLogin,
    required this.hasSeenTutorial,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'mobileNumber': mobileNumber,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'hasSeenTutorial': hasSeenTutorial,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      userId: documentId,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      role: map['role'] ?? 'student',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      lastLogin: map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : DateTime.now(),
      hasSeenTutorial: map['hasSeenTutorial'] ?? false,
    );
  }
}

class UserProfile {
  final String profileId;
  final String userId;
  final String studentStatus;
  final String currencyPreference;
  final String notificationPreference;
  final String? profileImage;

  UserProfile({
    required this.profileId,
    required this.userId,
    required this.studentStatus,
    required this.currencyPreference,
    required this.notificationPreference,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'studentStatus': studentStatus,
      'currencyPreference': currencyPreference,
      'notificationPreference': notificationPreference,
      'profileImage': profileImage,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String documentId) {
    return UserProfile(
      profileId: documentId,
      userId: map['userId'] ?? '',
      studentStatus: map['studentStatus'] ?? '',
      currencyPreference: map['currencyPreference'] ?? 'USD',
      notificationPreference: map['notificationPreference'] ?? 'All',
      profileImage: map['profileImage'],
    );
  }
}
