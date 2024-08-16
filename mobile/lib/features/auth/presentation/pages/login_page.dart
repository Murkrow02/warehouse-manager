import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_manager/features/auth/bloc/auth_bloc.dart';
import 'package:warehouse_manager/features/auth/data/repositories/auth_rest_repository.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocProvider(
        create: (context) => AuthBloc(authRepository: AuthRestRepository())
          ..add(AuthStatusCheck()),
        child: const _LoginView(),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthError) {
          return Text(state.message);
        } else if (state is AuthAuthenticated) {
          return Center(
              child: ElevatedButton(onPressed: (){
                context.read<AuthBloc>().add(AuthLogoutRequested());
              }, child: Text('Logout')));
        } else {
          return _buildLoginForm(context);
        }
      },
    );
  }
}

Widget _buildLoginForm(BuildContext context) {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(
                  AuthLoginRequested(
                    username: _usernameController.text,
                    password: _passwordController.text,
                  ),
                );
          },
          child: const Text('Login'),
        ),
      ],
    ),
  );
}
