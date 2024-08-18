import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warehouse_manager/common/widgets/error_alert.dart';
import 'package:warehouse_manager/common/widgets/form_field_spacer.dart';
import 'package:warehouse_manager/common/widgets/form_page.dart';
import 'package:warehouse_manager/common/widgets/form_wrapper.dart';
import 'package:warehouse_manager/common/widgets/loading.dart';
import 'package:warehouse_manager/features/items/bloc/form/item_form_bloc.dart';
import 'package:warehouse_manager/features/items/bloc/form/item_form_event.dart';
import '../../bloc/form/item_form_state.dart';
import '../../data/models/item.dart';
import '../../data/repositories/items_repository.dart';

class ItemFormPage extends StatelessWidget {
  final Item? item;

  ItemFormPage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return FormPage<Item, ItemFormBloc, ItemFormEvent, ItemFormState>(
        model: item,
        createBloc: (context) =>
            ItemFormBloc(itemRepository: context.read<ItemsRepository>())
              ..add(LoadItem(id: item?.id)),
        form: _buildForm);
  }

  Widget _buildForm(Item? item, GlobalKey<FormBuilderState> formKey) {
    return FormWrapper(
      child: FormBuilder(
        key: formKey,
        initialValue: item?.toFormData() ?? {},
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const FormFieldSpacer(),
            FormBuilderTextField(
              name: 'code',
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Code'),
            ),

            const FormFieldSpacer(),
            FormBuilderTextField(
              name: 'description',
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const FormFieldSpacer(),
            FormBuilderDropdown<String>(
              name: 'gender',
              decoration: const InputDecoration(labelText: 'Gender'),
              items: ['male', 'female', 'other']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
            ),
            const FormFieldSpacer(),
            FormBuilderTextField(
              name: 'purchase_price',
              decoration: const InputDecoration(labelText: 'Purchase Price'),
              valueTransformer: (value) => double.parse(value ?? '0'),
              keyboardType: TextInputType.number,
            ),
            const FormFieldSpacer(),
            FormBuilderTextField(
              name: 'sale_price',
              decoration: const InputDecoration(labelText: 'Sale Price'),
              valueTransformer: (value) => double.parse(value ?? '0'),
              keyboardType: TextInputType.number,
            ),
            const FormFieldSpacer(),
            FormBuilderTextField(
              name: 'vat',
              decoration: const InputDecoration(labelText: 'VAT'),
              keyboardType: TextInputType.number,
            ),
            const FormFieldSpacer(),
            FormBuilderTextField(
              name: 'min_stock_quantity',
              decoration:
                  const InputDecoration(labelText: 'Min Stock Quantity'),
              valueTransformer: (value) => int.parse(value ?? '0'),
              keyboardType: TextInputType.number,
            ),
            const FormFieldSpacer(),
            FormBuilderDateTimePicker(
              name: 'last_reorder_date',
              decoration: const InputDecoration(labelText: 'Last Reorder Date'),
              inputType: InputType.date,
            ),
            const FormFieldSpacer(),
            FormBuilderTextField(
              name: 'serial_number',
              decoration: const InputDecoration(labelText: 'Serial Number'),
            ),
            const FormFieldSpacer(),
            FormBuilderTextField(
              name: 'supplier.name',
              decoration: const InputDecoration(labelText: 'Supplier Name'),
            ),
            const FormFieldSpacer(),
            FormBuilderTextField(
              name: 'supplier.contact_details',
              decoration:
                  const InputDecoration(labelText: 'Supplier Contact Details'),
            ),
            const FormFieldSpacer(),
            FormBuilderTextField(
              name: 'supplier.payment_details',
              decoration:
                  const InputDecoration(labelText: 'Supplier Payment Details'),
            ),
            const FormFieldSpacer(),
            // FormBuilderDropdown<int>(
            //   name: 'categories',
            //   decoration: const InputDecoration(labelText: 'Categories'),
            //   items: item?.categories
            //       .map((category) => DropdownMenuItem(
            //     value: category.id,
            //     child: Text(category.name),
            //   ))
            //       .toList() ??
            //       [],
            // ),
          ],
        ),
      ),
    );
  }
}

// class ItemFormPage extends StatelessWidget {
//   final formKey = GlobalKey<FormBuilderState>();
//   final Item? item;
//
//   ItemFormPage({super.key, this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ItemFormBloc(itemRepository: context.read<ItemsRepository>())..add(LoadItem(id: item?.id)),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Articolo'),
//           actions: item == null ? null : [
//             IconButton(
//               icon: const Icon(Icons.barcode_reader),
//               onPressed: () async {
//                 // Show the dialog
//                 await showDialog(
//                   context: context,
//                   builder: (context) => BarcodePrinterDialog(code: item!.code),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: BlocBuilder<ItemFormBloc, ItemFormState>(
//           builder: (context, state) {
//             if (state is ItemLoading) {
//               return const Center(
//                 child: Loading(),
//               );
//             } else if (state is ItemLoaded) {
//               return _buildForm(state.item);
//             } else if (state is ItemApiValidationError) {
//               state.validationException.applyToForm(formKey.currentState!);
//               return _buildForm(state.item);
//             } else if (state is ItemError) {
//               return ErrorAlert(state.error);
//             }
//             return const Center(
//               child: Text('Errore'),
//             );
//           },
//         ),
//         floatingActionButton: Builder(
//           builder: (context) {
//             return FloatingActionButton(
//               onPressed: () async {
//                 if (formKey.currentState!.saveAndValidate()) {
//                   final formData = formKey.currentState!.value;
//                   final item = Item.fromFormData(formData);
//                   BlocProvider.of<ItemFormBloc>(context)
//                       .add(CreateItem(item: item));
//                 }
//               },
//               child: const Icon(Icons.save),
//             );
//           }
//         ),
//       ),
//     );
//   }
//
//
//
//
// }
//
