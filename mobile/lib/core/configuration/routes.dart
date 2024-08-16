import 'package:flutter/material.dart';
import 'package:warehouse_manager/features/items/presentation/pages/item_form_page.dart';
import 'package:warehouse_manager/features/items/presentation/pages/items_list_page.dart';

class Routes {

  static const String items = '/items';
  static const String item = '/item';

  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      items: (context) =>  ItemsListPage(),
      item: (context) =>  ItemFormPage(),
    };
  }
}