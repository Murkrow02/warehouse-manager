import 'package:bloc/bloc.dart';

import '../data/repositories/items_repository.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemFormBloc extends Bloc<ItemEvent, ItemState> {
  final ItemsRepository itemRepository;

  ItemFormBloc({required this.itemRepository}) : super(ItemLoading()) {
    on<UpdateItem>(_onUpdateItem);
    on<CreateItem>(_onCreateItem);
  }

  Future<void> _onUpdateItem(UpdateItem event, Emitter<ItemState> emit) async {
    try {
      final updatedItem = await itemRepository.updateItem(event.item);
      emit(ItemOperationSuccess(item: updatedItem));
    } catch (error) {
      emit(ItemError(message: error.toString()));
    }
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
