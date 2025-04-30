class UserModel {
  final String name;
  final String email;
  final DateTime createdAt;
  final String role;
  final String firebaseUid;
  final String imageUrl;
  final DateTime lastSignInTime;

  UserModel( {
    required this.name,
    required this.email,
    required this.createdAt,
    required this.imageUrl,
    required this.role,
    required this.firebaseUid,
    required this.lastSignInTime,
  });

  // Factory method to create a UserModel from JSON
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      imageUrl: map['imageUrl']??'',
      email: map['email'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      role: map['role'] as String,
      firebaseUid: map['firebaseUid'] as String,
      lastSignInTime: DateTime.parse(map['lastSignInTime']),
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'role': role,
      'firebaseUid': firebaseUid,
      'lastSignInTime': lastSignInTime.toIso8601String(),
    };
  }
}
