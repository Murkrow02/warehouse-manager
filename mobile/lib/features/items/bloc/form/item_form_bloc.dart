import 'package:bloc/bloc.dart';
import 'package:warehouse_manager/common/bloc/form/form_event.dart';
import 'package:warehouse_manager/common/bloc/form/form_state.dart';
import '../../../../core/exceptions/api_validation_exception.dart';
import '../../../../core/models/traced_error.dart';
import '../../data/models/item.dart';
import '../../data/repositories/items_repository.dart';

class ItemFormBloc extends Bloc<FormEventBase, FormStateBase> {
  final ItemsRepository itemRepository;

  ItemFormBloc({required this.itemRepository}) : super(FormLoadingState()) {
    on<LoadFormModel<Item>>(_onLoadItem);
    on<UpdateFormModel>(_onUpdateItem);
    on<CreateFormModel>(_onCreateItem);
  }


  Future<void> _onLoadItem(LoadFormModel<Item> event, Emitter<FormStateBase> emit) async {
    try {
      final item = event.model != null ? await itemRepository.fetchItem(event.model!.id) : Item();
      emit(FormReadyState<Item>(model: item));
    } catch (error) {
      print('Error occurred: $error'); // Handle error
      emit(FormErrorState(error: error)); // Example of handling an error state
    }
  }

  Future<void> _onUpdateItem(UpdateFormModel event, Emitter<FormStateBase> emit) async {
    try {
      final updatedItem = await itemRepository.updateItem(event.model);
      //emit(ItemOperationSuccess(item: updatedItem));
    } catch (error) {
      //emit(ItemError(message: error.toString()));
    }
  }

  Future<void> _onCreateItem(CreateFormModel event, Emitter<FormStateBase> emit) async {
    try {
      final newItem = await itemRepository.createItem(event.model);
      //emit(ItemOperationSuccess(item: newItem));
    }
    on ApiValidationException catch (e) {
  //    emit(ItemApiValidationError(validationException: e, model: event.item));
    }
    catch (e,s) {
    //  emit(ItemError(error: TracedError(e, s)));
    }
  }

}
