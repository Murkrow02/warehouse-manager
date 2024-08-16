import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_manager/features/auth/data/repositories/auth_rest_repository.dart';
import 'package:warehouse_manager/features/items/bloc/item_form_bloc.dart';

import '../../bloc/item_event.dart';
import '../../data/repositories/items_repository.dart';

class ItemFormPage extends StatelessWidget {
  const ItemFormPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Articolo'),
      ),
      body: BlocProvider(
        create: (_) =>
        ItemFormBloc(itemRepository: context.read<ItemsRepository>())
          ..add(LoadItem(id: 1)),
        child: _ItemFormView(),
      ),
    );
  }
}

