// lib/blocs/item/item_create_bloc.dart

import 'package:bloc/bloc.dart';
import '../data/repositories/items_repository.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemCreateBloc extends Bloc<ItemEvent, ItemState> {
  final ItemsRepository itemRepository;

  ItemCreateBloc({required this.itemRepository}) : super(ItemLoading()) {
    on<CreateItem>(_onCreateItem);
  }

  Future<void> _onCreateItem(CreateItem event, Emitter<ItemState> emit) async {
    try {
      final newItem = await itemRepository.createItem(event.item);
      emit(ItemOperationSuccess(item: newItem));
    } catch (error) {
      emit(ItemError(message: error.toString()));
    }
  }
}
