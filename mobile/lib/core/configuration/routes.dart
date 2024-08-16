import 'package:flutter/material.dart';
import 'package:warehouse_manager/features/auth/presentation/pages/login_page.dart';
import 'package:warehouse_manager/features/items/presentation/pages/item_form_page.dart';
import 'package:warehouse_manager/features/items/presentation/pages/items_table_page.dart';

import '../../features/debug/presentation/pages/debug_page.dart';

class Routes {

  static const String login = '/login';
  static const String items = '/items';
  static const String item = '/item';
  static const String debug = '/debug';

  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      login: (context) =>  LoginPage(),
      items: (context) =>  ItemsListPage(),
      item: (context) =>  ItemFormPage(),
      debug: (context) =>  DebugPage(),
    };
  }
}