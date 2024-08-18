import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warehouse_manager/common/bloc/form/form_state.dart';
import 'package:warehouse_manager/common/widgets/error_alert.dart';
import 'package:warehouse_manager/common/widgets/loading.dart';
import 'package:warehouse_manager/core/exceptions/unexpected_state_exception.dart';
import 'package:warehouse_manager/core/models/traced_error.dart';

import '../../features/items/bloc/form/item_form_state.dart';
import 'form_wrapper.dart';

class FormPage<T, B extends Bloc<E, S>, E, S> extends StatelessWidget {
  final T? model;
  final Widget Function(T? model, GlobalKey<FormBuilderState> formKey) form;
  final B Function(BuildContext context) createBloc;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

   FormPage(
      {super.key, this.model, required this.createBloc, required this.form});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: createBloc,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Form')),
            body: BlocBuilder<B, S>(
              builder: (context, state) {
                // Loading
                if (state is FormLoadingState) {
                  return const Loading();
                }

                // Ready
                else if (state is FormReadyState) {
                  return form(model, formKey);
                }

                // Validation Error
                else if (state is FormApiValidationErrorState) {
                  // Apply validation errors to form fields before rendering the form
                  state.validationException.applyToForm(formKey.currentState!);
                  return form(state.model, formKey);
                }

                return ErrorAlert(TracedError(UnexpectedStateException(), StackTrace.current));
              },
            ),
          );
        },
      ),
    );
  }
}
