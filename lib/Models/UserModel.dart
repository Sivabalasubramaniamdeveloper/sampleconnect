import 'package:cloud_firestore/cloud_firestore.dart';

class UserListModel {
  final String name;
  final String email;
  final Timestamp createdAt;
  final String role;
  final String firebaseUid;
  final String imageUrl;
  final Timestamp lastSeen;
  final String status;


  UserListModel({
    required this.name,
    required this.email,
    required this.createdAt,
    required this.imageUrl,
    required this.role,
    required this.firebaseUid,
    required this.lastSeen,
    required this.status,
  });

  // ✅ Correct factory using Firestore Timestamp
  factory UserListModel.fromMap(Map<String, dynamic> map) {
    return UserListModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt'] as Timestamp,
      role: map['role'] ?? '',
      firebaseUid: map['firebaseUid'] ?? '',
      status: map['status'] ?? '',
      lastSeen: map['lastSeen'] as Timestamp,
    );
  }

  // ✅ Correct toMap using Timestamp directly
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'role': role,
      'firebaseUid': firebaseUid,
      'status': status,
      'lastSeen': lastSeen,
    };
  }
}
