import 'package:warehouse_manager/core/models/has_form.dart';
import 'package:warehouse_manager/core/models/serializable.dart';
import '../../../suppliers/data/models/supplier.dart';
import 'category.dart';

class Item implements Serializable, HasForm {

  final int id;
  final String code;
  final String name;
  final String description;
  final String gender;
  final double purchasePrice;
  final double salePrice;
  final double vat;
  final int minStockQuantity;
  DateTime lastReorderDate = DateTime.now();
  final String serialNumber;
  Supplier supplier = Supplier();
  final List<Category> categories;

  Item({
    this.id = 0,
    this.code = "",
    this.name = "",
    this.description = "",
    this.gender = "",
    this.purchasePrice = 0.0,
    this.salePrice = 0.0,
    this.vat = 0.0,
    this.minStockQuantity = 0,
    this.serialNumber = "",
    //this.supplier = const Supplier(),
    this.categories = const [],
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? 0,
      code: json['code'],
      name: json['name'],
      description: json['description'],
      gender: json['gender'],
      purchasePrice: json['purchase_price'],
      salePrice: json['sale_price'],
      vat: double.parse(json['vat']),
      minStockQuantity: json['min_stock_quantity'],
     // lastReorderDate: DateTime.parse(json['last_reorder_date']),
      serialNumber: json['serial_number'],
     // supplier: Supplier.fromJson(json['supplier']),
     //  categories: (json['categories'] as List)
     //      .map((category) => Category.fromJson(category))
     //      .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'gender': gender,
      'purchase_price': purchasePrice,
      'sale_price': salePrice,
      'vat': vat,
      'min_stock_quantity': minStockQuantity,
      'last_reorder_date': lastReorderDate.toString(),
      'serial_number': serialNumber,
     // 'supplier': supplier.toJson(),
    //  'categories': categories.map((category) => category.toJson()).toList(),
    };
  }

  @override
  Map<String, dynamic> toFormData() {
    return {
      'id': id.toString(),
      'code': code,
      'name': name,
      'description': description
    };
  }

  @override
  factory Item.fromFormData(Map<String, dynamic> formData) {
    return Item(
      id: 0,
      code: formData['code'],
      name: formData['name'],
      description: formData['description'],
    );
  }
}
