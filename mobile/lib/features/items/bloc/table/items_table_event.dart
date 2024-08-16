import 'package:equatable/equatable.dart';

import '../../data/models/item.dart';

abstract class ItemsTableEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Events for listing items
class LoadItems extends ItemsTableEvent {
  final int startIndex;
  final int limit;
  final String? query;
  final String? sortBy;
  final bool? ascending;

  LoadItems({this.startIndex = 0, this.limit = 20, this.query, this.sortBy, this.ascending});

  @override
  List<Object?> get props => [startIndex, limit, query, sortBy, ascending];
}

// Events for searching items
class SearchItems extends ItemsTableEvent {
  final String query;

  SearchItems({required this.query});

  @override
  List<Object?> get props => [query];
}

// Events for sorting items
class SortItems extends ItemsTableEvent {
  final String sortBy;
  final bool ascending;

  SortItems({required this.sortBy, required this.ascending});

  @override
  List<Object?> get props => [sortBy, ascending];
}
