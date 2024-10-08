import 'package:equatable/equatable.dart';
import 'package:warehouse_manager/core/models/traced_error.dart';
import '../../data/models/item.dart';

abstract class ItemsTableState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItemsLoading extends ItemsTableState {}

class ItemsLoaded extends ItemsTableState {
  final List<Item> items;
  final bool hasReachedMax;

  ItemsLoaded({required this.items, this.hasReachedMax = false});

  ItemsLoaded copyWith({List<Item>? items, bool? hasReachedMax}) {
    return ItemsLoaded(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [items, hasReachedMax];
}

class ItemsError extends ItemsTableState {
  final TracedError error;
  ItemsError({required this.error});

  @override
  List<Object> get props => [error];
}
