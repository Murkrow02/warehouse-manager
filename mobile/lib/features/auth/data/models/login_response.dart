import 'package:warehouse_manager/core/models/serializable.dart';

class LoginResponse implements Serializable {
  final String token;

  LoginResponse({required this.token});

  @override
  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
    );
  }
}