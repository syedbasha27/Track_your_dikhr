import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents the authenticated user profile stored in Firestore
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
