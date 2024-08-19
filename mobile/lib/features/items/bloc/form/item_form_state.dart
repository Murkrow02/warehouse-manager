import 'package:equatable/equatable.dart';
import 'package:warehouse_manager/common/bloc/form/form_state.dart';




//
// abstract class ItemFormState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }
//
// class ItemLoading extends ItemFormState implements FormLoadingState {}
//
// class ItemLoaded extends ItemFormState implements FormReadyState {
//   final Item item;
//
//   ItemLoaded({required this.item});
//
//   @override
//   List<Object?> get props => [item];
// }
//
// class ItemError extends ItemFormState {
//   final TracedError error;
//
//   ItemError({required this.error});
//
//   @override
//   List<Object> get props => [error];
// }
//
// class ItemApiValidationError extends ItemFormState implements FormApiValidationErrorState {
//
//   @override
//   final ApiValidationException validationException;
//   @override
//   final Item model;
//
//   ItemApiValidationError({required this.validationException, required this.model});
//
//   @override
//   List<Object?> get props => [validationException, model];
//
// }
