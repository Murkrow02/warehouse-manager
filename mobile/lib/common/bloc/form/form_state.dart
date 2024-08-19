import 'package:equatable/equatable.dart';
import 'package:warehouse_manager/core/exceptions/api_validation_exception.dart';

abstract class FormStateBase extends Equatable {
  @override
  List<Object?> get props => [];
}

class FormLoadingState extends FormStateBase {}

class FormReadyState<T extends Object> extends FormStateBase {
  final T model;

  FormReadyState({required this.model});

  @override
  List<Object> get props => [model];
}

class FormErrorState extends FormStateBase {
  final Object error;

  FormErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class FormApiValidationErrorState<T extends Object> extends FormStateBase {
  final ApiValidationException validationException;
  final T model;

  FormApiValidationErrorState({required this.validationException, required this.model});

  @override
  List<Object?> get props => [validationException, model];
}

