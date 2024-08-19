import 'package:equatable/equatable.dart';

abstract class FormEventBase extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFormModel<T> extends FormEventBase {
  final T? model;
  LoadFormModel({this.model});

  @override
  List<Object?> get props => [model];
}


class CreateFormModel<T> extends FormEventBase {
  final T model;
  CreateFormModel({required this.model});

  @override
  List<Object?> get props => [model];
}

class UpdateFormModel<T> extends FormEventBase {
  final T model;

  UpdateFormModel({required this.model});

  @override
  List<Object?> get props => [model];
}
