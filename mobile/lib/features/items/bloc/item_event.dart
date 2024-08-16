import 'package:equatable/equatable.dart';

import '../data/models/item.dart';

abstract class ItemEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Events for listing items
class LoadItems extends ItemEvent {
  final int startIndex;
  final int limit;
  final String? query;
  final String? sortBy;
  final bool? ascending;

  LoadItems({this.startIndex = 0, this.limit = 20, this.query, this.sortBy, this.ascending});

  @override
  List<Object?> get props => [startIndex, limit, query, sortBy, ascending];
}

// Events for loading a single item
class LoadItem extends ItemEvent {
  final int id;

  LoadItem({required this.id});

  @override
  List<Object?> get props => [id];
}

// Events for searching items
class SearchItems extends ItemEvent {
  final String query;

  SearchItems({required this.query});

  @override
  List<Object?> get props => [query];
}

// Events for sorting items
class SortItems extends ItemEvent {
  final String sortBy;
  final bool ascending;

  SortItems({required this.sortBy, required this.ascending});

  @override
  List<Object?> get props => [sortBy, ascending];
}

// Events for creating a new item
class CreateItem extends ItemEvent {
  final Item item;

  CreateItem({required this.item});

  @override
  List<Object?> get props => [item];
}

// Events for updating an existing item
class UpdateItem extends ItemEvent {
  final Item item;

  UpdateItem({required this.item});

  @override
  List<Object?> get props => [item];
}
