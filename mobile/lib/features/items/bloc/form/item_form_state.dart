import 'package:equatable/equatable.dart';

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
  final String message;

  ItemError({required this.message});

  @override
  List<Object?> get props => [message];
}