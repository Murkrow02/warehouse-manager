import 'package:flutter_form_builder/src/form_builder.dart';

class ApiValidationException implements Exception {
  final Map<String, List<dynamic>> errors;

  ApiValidationException(this.errors);

  void applyToForm(FormBuilderState formBuilderState) {
    formBuilderState.fields.forEach((key, field) {
      if (errors.containsKey(key)) {
        field.invalidate("${errors[key]!.join('\n')}");
      }
    });
  }
}
