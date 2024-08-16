import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_manager/common/widgets/form_wrapper.dart';
import 'package:warehouse_manager/features/items/bloc/form/item_form_bloc.dart';
import 'package:warehouse_manager/features/items/bloc/form/item_form_event.dart';
import '../../bloc/form/item_form_state.dart';
import '../../data/models/item.dart';
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
        child: BlocBuilder<ItemFormBloc, ItemFormState>(
          builder: (context, state) {
            if (state is ItemLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else
            if (state is ItemLoaded) {
              return _buildForm(state.item);
            } else if (state is ItemError) {
              return Center(
                child: Text(state.message),
              );
            }
            return const Center(
              child: Text('Errore'),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildForm(Item item) {
  return FormWrapper(
    child: Column(
      children: [
        Text(item.name),
      ],
    ),
  );
}



