import 'package:warehouse_manager/core/models/serializable.dart';

class User implements Serializable {
  final int id;
  final String email;
  final String name;
  User({
    required this.id,
    required this.email,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }
}