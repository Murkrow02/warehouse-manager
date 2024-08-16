import 'package:bloc/bloc.dart';
import 'package:warehouse_manager/features/items/bloc/form/item_form_state.dart';
import '../../data/repositories/items_repository.dart';
import 'item_form_event.dart';

class ItemFormBloc extends Bloc<ItemFormEvent, ItemFormState> {
  final ItemsRepository itemRepository;

  ItemFormBloc({required this.itemRepository}) : super(ItemLoading()) {
    on<UpdateItem>(_onUpdateItem);
    on<CreateItem>(_onCreateItem);
    on<LoadItem>(_onLoadItem);
  }

  Future<void> _onUpdateItem(UpdateItem event, Emitter<ItemFormState> emit) async {
    try {
      final updatedItem = await itemRepository.updateItem(event.item);
      //emit(ItemOperationSuccess(item: updatedItem));
    } catch (error) {
      //emit(ItemError(message: error.toString()));
    }
  }

  Future<void> _onCreateItem(CreateItem event, Emitter<ItemFormState> emit) async {
    try {
      final newItem = await itemRepository.createItem(event.item);
      //emit(ItemOperationSuccess(item: newItem));
    } catch (error) {
      //emit(ItemError(message: error.toString()));
    }
  }

  Future<void> _onLoadItem(LoadItem event, Emitter<ItemFormState> emit) async {
    try {
      final item = await itemRepository.fetchItem(event.id);
      emit(ItemLoaded(item: item));
    } catch (error) {
      emit(ItemError(message: error.toString()));
    }
  }
}
