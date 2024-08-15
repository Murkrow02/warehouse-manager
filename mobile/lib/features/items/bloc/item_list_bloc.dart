// lib/blocs/item/item_list_bloc.dart

import 'package:bloc/bloc.dart';

import '../data/repositories/items_repository.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemListBloc extends Bloc<ItemEvent, ItemState> {
  final ItemsRepository itemRepository;

  ItemListBloc({required this.itemRepository}) : super(ItemLoading()) {
    on<LoadItems>(_onLoadItems);
    on<SearchItems>(_onSearchItems);
    on<SortItems>(_onSortItems);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<ItemState> emit) async {
    try {

      final items = await itemRepository.fetchItems(
        startIndex: event.startIndex,
        limit: event.limit,
        query: event.query,
        sortBy: event.sortBy,
        ascending: event.ascending,
      );
      emit(ItemLoaded(items: items, hasReachedMax: items.length < event.limit));
    } catch (error) {
      emit(ItemError(message: error.toString()));
    }
  }

  Future<void> _onSearchItems(SearchItems event, Emitter<ItemState> emit) async {
    add(LoadItems(query: event.query));
  }

  Future<void> _onSortItems(SortItems event, Emitter<ItemState> emit) async {
    add(LoadItems(sortBy: event.sortBy, ascending: event.ascending));
  }
}
