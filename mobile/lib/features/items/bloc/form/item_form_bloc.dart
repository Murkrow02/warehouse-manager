import 'package:bloc/bloc.dart';
import 'package:warehouse_manager/common/bloc/form/form_event.dart';
import 'package:warehouse_manager/common/bloc/form/form_state.dart';
import '../../../../core/exceptions/api_validation_exception.dart';
import '../../../../core/models/traced_error.dart';
import '../../data/models/item.dart';
import '../../data/repositories/items_repository.dart';
import 'item_form_event.dart';

class ItemFormBloc extends Bloc<FormEventBase, FormStateBase> {
  final ItemsRepository itemRepository;

  ItemFormBloc({required this.itemRepository}) : super(FormLoadingState()) {
    on<UpdateFormModel>(_onUpdateItem);
    on<CreateFormModel>(_onCreateItem);
    on<LoadFormModel>(_onLoadItem);
  }


  Future<void> _onLoadItem(LoadFormModel event, Emitter<FormStateBase> emit) async {
    try {
      final item = event.id != null ? await itemRepository.fetchItem(event.id!) : Item();
      emit(FormReadyState(model: item));
    } catch (e,s) {
     // emit(ItemError(error: TracedError(e, s)));
    }
  }

  Future<void> _onUpdateItem(UpdateFormModel event, Emitter<FormStateBase> emit) async {
    try {
      final updatedItem = await itemRepository.updateItem(event.item);
      //emit(ItemOperationSuccess(item: updatedItem));
    } catch (error) {
      //emit(ItemError(message: error.toString()));
    }
  }

  Future<void> _onCreateItem(CreateFormModel event, Emitter<FormStateBase> emit) async {
    try {
      final newItem = await itemRepository.createItem(event.item);
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
