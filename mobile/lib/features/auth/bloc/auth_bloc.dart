import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_manager/core/configuration/preferences.dart';
import 'package:warehouse_manager/features/auth/data/models/user.dart';
import '../../../core/models/traced_error.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthStatusCheck>(_onStatusCheck);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  void _onStatusCheck(AuthStatusCheck event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      var prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Preferences.AUTH_TOKEN);
      if (token != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (error) {
      emit(AuthUnauthenticated());
    }
  }

  void _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.login(event.username, event.password);
      emit(AuthAuthenticated());
    } catch (e,s) {
      emit(AuthError(error: TracedError(e, s)));
    }
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e,s) {
      emit(AuthError(error: TracedError(e, s)));
    }
  }
}
