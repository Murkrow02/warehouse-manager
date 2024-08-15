import 'package:equatable/equatable.dart';

import '../data/models/item.dart';


abstract class ItemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItemLoading extends ItemState {

}

class ItemLoaded extends ItemState {
  final List<Item> items;
  final bool hasReachedMax;

  ItemLoaded({required this.items, this.hasReachedMax = false});

  ItemLoaded copyWith({List<Item>? items, bool? hasReachedMax}) {
    return ItemLoaded(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [items, hasReachedMax];
}

class ItemOperationSuccess extends ItemState {
  final Item item;

  ItemOperationSuccess({required this.item});

  @override
  List<Object?> get props => [item];
}

class ItemError extends ItemState {
  final String message;

  ItemError({required this.message});

  @override
  List<Object?> get props => [message];
}
