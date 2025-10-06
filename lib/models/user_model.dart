// lib/models/user_model.dart

import 'package:flutter/foundation.dart';

@immutable
class User {
  final int id;
  final String username;
  final String email;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? 'N/A',
      email: json['email'] as String? ?? 'N/A',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
