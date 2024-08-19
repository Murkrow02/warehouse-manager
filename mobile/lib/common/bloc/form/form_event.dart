import 'package:equatable/equatable.dart';

abstract class FormEventBase extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFormModel extends FormEventBase {
  final int? id;

  LoadFormModel({this.id});

  @override
  List<Object?> get props => [id];
}


class CreateFormModel<T> extends FormEventBase {
  final T item;

  CreateFormModel({required this.item});

  @override
  List<Object?> get props => [item];
}

class UpdateFormModel<T> extends FormEventBase {
  final T item;

  UpdateFormModel({required this.item});

  @override
  List<Object?> get props => [item];
}
