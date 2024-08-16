import 'package:bloc/bloc.dart';
import 'package:warehouse_manager/features/items/bloc/table/items_table_state.dart';
import '../../data/repositories/items_repository.dart';
import 'items_table_event.dart';


class ItemsTableBloc extends Bloc<ItemsTableEvent, ItemsTableState> {
  final ItemsRepository itemRepository;

  ItemsTableBloc({required this.itemRepository}) : super(ItemsLoading()) {
    on<LoadItems>(_onLoadItems);
    on<SearchItems>(_onSearchItems);
    on<SortItems>(_onSortItems);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<ItemsTableState> emit) async {
    try {

      final items = await itemRepository.fetchItems(
        startIndex: event.startIndex,
        limit: event.limit,
        query: event.query,
        sortBy: event.sortBy,
        ascending: event.ascending,
      );
      emit(ItemsLoaded(items: items, hasReachedMax: items.length < event.limit));
    } catch (error) {
      //emit(ItemError(message: error.toString()));
    }
  }

  Future<void> _onSearchItems(SearchItems event, Emitter<ItemsTableState> emit) async {
    add(LoadItems(query: event.query));
  }

  Future<void> _onSortItems(SortItems event, Emitter<ItemsTableState> emit) async {
    add(LoadItems(sortBy: event.sortBy, ascending: event.ascending));
  }
}
