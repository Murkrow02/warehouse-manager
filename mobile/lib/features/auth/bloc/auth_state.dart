import 'package:equatable/equatable.dart';
import 'package:warehouse_manager/core/models/traced_error.dart';
import '../data/models/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthChecking extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final TracedError error;

  AuthError({required this.error});

  @override
  List<Object> get props => [error];
}
