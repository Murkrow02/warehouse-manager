import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthStatusCheck extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  AuthLoginRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class AuthLogoutRequested extends AuthEvent {}
