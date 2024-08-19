import 'package:flutter_form_builder/src/form_builder.dart';

class ApiValidationException implements Exception {
  final Map<String, List<dynamic>> errors;
  ApiValidationException(this.errors);
}
