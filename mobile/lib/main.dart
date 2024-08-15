import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_manager/features/items/data/repositories/items_mock_repository.dart';
import 'package:warehouse_manager/features/items/data/repositories/items_repository.dart';

import 'features/items/presentation/pages/items_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ItemsRepository>(
      // Swap between real and mock implementations here
      create: (context) => ItemsMockRepository(),
      // or use: create: (context) => RealItemsRepository(),
      child: MaterialApp(
        title: 'Flutter Item Manager',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ItemsListPage(),
      ),
    );
  }
}