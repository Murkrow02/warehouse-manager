import 'package:warehouse_manager/core/exceptions/api_validation_exception.dart';

class FormLoadingState {}
class FormReadyState {}
class FormApiValidationErrorState<T> {
  final ApiValidationException validationException;
  final T model;
  FormApiValidationErrorState({required this.validationException, required this.model});
}