import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warehouse_manager/common/bloc/form/form_event.dart';
import 'package:warehouse_manager/common/bloc/form/form_state.dart';
import 'package:warehouse_manager/common/widgets/error_alert.dart';
import 'package:warehouse_manager/common/widgets/loading.dart';
import 'package:warehouse_manager/core/exceptions/unexpected_state_exception.dart';
import '../../core/models/traced_error.dart';

/*
  * FormPage is a generic widget that can be used to create a form page with a form bloc.
  * The states and events are pre-defined foreach form, you only need to implement the bloc and the form.
  * This handles the API-validation errors and invalidates the fields with errors.
 */

class FormPage<Model extends Object,
        FormModelBloc extends Bloc<FormEventBase, FormStateBase>>
    extends StatelessWidget {
  final Model? model;
  final Widget Function(Model? model, GlobalKey<FormBuilderState> formKey) form;
  final FormModelBloc Function(BuildContext context) createFormBloc;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  FormPage(
      {super.key,
      this.model,
      required this.createFormBloc,
      required this.form});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormModelBloc>(
      create: createFormBloc,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Form')),
            body: BlocBuilder<FormModelBloc, FormStateBase>(
              builder: (context, state) {
                // Loading
                if (state is FormLoadingState) {
                  return const Loading();
                }

                // Ready
                else if (state is FormReadyState<Model>) {
                  return form(state.model, formKey);
                }

                // Validation Error from API
                else if (state is FormApiValidationErrorState<Model>) {
                  // Invalidate fields with errors
                  formKey.currentState!.fields.forEach((key, field) {
                    if (state.validationException.errors.containsKey(key)) {
                      field.invalidate(
                          state.validationException.errors[key]!.join('\n'));
                    }
                  });

                  return form(state.model, formKey);
                }

                return ErrorAlert(TracedError(
                    UnexpectedStateException(), StackTrace.current));
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (formKey.currentState!.saveAndValidate()) {
                  // context.read<B>().add(SaveItem(model: model));
                }
              },
              child: const Icon(Icons.save),
            ),
          );
        },
      ),
    );
  }
}
