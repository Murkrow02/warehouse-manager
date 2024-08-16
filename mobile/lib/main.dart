import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:warehouse_manager/core/configuration/app_color_scheme.dart';
import 'package:warehouse_manager/core/configuration/routes.dart';
import 'package:warehouse_manager/features/auth/data/repositories/auth_repository.dart';
import 'package:warehouse_manager/features/auth/data/repositories/auth_rest_repository.dart';
import 'package:warehouse_manager/features/debug/presentation/pages/debug_page.dart';
import 'package:warehouse_manager/features/items/data/repositories/items_mock_repository.dart';
import 'package:warehouse_manager/features/items/data/repositories/items_repository.dart';
import 'package:warehouse_manager/features/items/data/repositories/items_rest_repository.dart';

import 'features/items/presentation/pages/items_table_page.dart';

void main() {
  runApp(ToastificationWrapper(child: App()));
}



class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider<ItemsRepository>(
        create: (context) => ItemsRestRepository(),
      ),
      RepositoryProvider<AuthRepository>(
        create: (context) => AuthRestRepository(),
      ),
    ], child: MaterialApp(
        title: 'Warehouse Manager',
        debugShowCheckedModeBanner: false,
        routes: Routes.getRoutes(),
        theme: ThemeData(
          colorScheme: AppTheme.getDefaultColorScheme(),
        ),
        home: const DebugPage(),
      // ElevatedButton(onPressed: () async {
      //   var a=new AuthRestRepository();
      //   await a.login('a@a.it', 'password');
      // }, child: Text('Login')),
      ),
    );
  }
}
