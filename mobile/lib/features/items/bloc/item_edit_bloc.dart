import 'package:bloc/bloc.dart';

import '../data/repositories/items_repository.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemEditBloc extends Bloc<ItemEvent, ItemState> {
  final ItemsRepository itemRepository;

  ItemEditBloc({required this.itemRepository}) : super(ItemLoading()) {
    on<UpdateItem>(_onUpdateItem);
  }

  Future<void> _onUpdateItem(UpdateItem event, Emitter<ItemState> emit) async {
    try {
      final updatedItem = await itemRepository.updateItem(event.item);
      emit(ItemOperationSuccess(item: updatedItem));
    } catch (error) {
      emit(ItemError(message: error.toString()));
    }
  }
}
