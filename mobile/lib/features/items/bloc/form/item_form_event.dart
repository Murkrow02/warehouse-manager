import 'package:equatable/equatable.dart';

import '../../data/models/item.dart';

abstract class ItemFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event for loading an existing item
class LoadItem extends ItemFormEvent {
  final int id;

  LoadItem({required this.id});

  @override
  List<Object?> get props => [id];
}


// Events for creating a new item
class CreateItem extends ItemFormEvent {
  final Item item;

  CreateItem({required this.item});

  @override
  List<Object?> get props => [item];
}

// Events for updating an existing item
class UpdateItem extends ItemFormEvent {
  final Item item;

  UpdateItem({required this.item});

  @override
  List<Object?> get props => [item];
}

