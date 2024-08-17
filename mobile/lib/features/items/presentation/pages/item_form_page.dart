import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warehouse_manager/common/widgets/form_field_spacer.dart';
import 'package:warehouse_manager/common/widgets/form_wrapper.dart';
import 'package:warehouse_manager/features/barcodes/presentation/dialogs/barcode_printer_dialog.dart';
import 'package:warehouse_manager/features/items/bloc/form/item_form_bloc.dart';
import 'package:warehouse_manager/features/items/bloc/form/item_form_event.dart';
import '../../bloc/form/item_form_state.dart';
import '../../data/models/item.dart';
import '../../data/repositories/items_repository.dart';

class ItemFormPage extends StatelessWidget {

  final Item? item;
  const ItemFormPage({super.key, this.item});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.save),
      ),
      appBar: AppBar(
        title: const Text('Articolo'),
        actions: item == null ? null : [
          IconButton(
            icon: const Icon(Icons.barcode_reader),
            onPressed: () async {
              // Show the dialog
              await showDialog(
                context: context,
                builder: (context) => BarcodePrinterDialog(code: item!.code),
              );
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => ItemFormBloc(itemRepository: context.read<ItemsRepository>())..add(LoadItem(id: item?.id)),
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

Widget _buildForm(Item? item) {

  final _formKey = GlobalKey<FormBuilderState>();

  return FormWrapper(
    child: FormBuilder(
      key: _formKey,
      initialValue: item != null ? item.toMap() : {},
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'name',
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          const FormFieldSpacer(),
          FormBuilderTextField(
            name: 'code',
            decoration: const InputDecoration(labelText: 'Codice'),
          ),
        ],
      ),
    ),
  );
}



