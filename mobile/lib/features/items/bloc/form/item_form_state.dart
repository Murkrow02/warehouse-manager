import 'package:equatable/equatable.dart';
import 'package:warehouse_manager/core/exceptions/api_validation_exception.dart';
import 'package:warehouse_manager/core/models/traced_error.dart';

import '../../data/models/item.dart';

abstract class ItemFormState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItemLoading extends ItemFormState {}

class ItemLoaded extends ItemFormState {
  final Item item;

  ItemLoaded({required this.item});

  @override
  List<Object?> get props => [item];
}

class ItemError extends ItemFormState {
  final TracedError error;

  ItemError({required this.error});

  @override
  List<Object> get props => [error];
}

class ItemApiValidationError extends ItemFormState {
  final ApiValidationException validationException;
  final Item item;

  ItemApiValidationError({required this.validationException, required this.item});

  @override
  List<Object> get props => [validationException, item];
}
