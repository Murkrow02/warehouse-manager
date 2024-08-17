import 'package:warehouse_manager/core/models/serializable.dart';

class Item implements Serializable {
  final int id;
  final String name;
  final String code;

  Item({this.id = 0, this.name = "", this.code = ""});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}