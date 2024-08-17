import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_manager/features/auth/bloc/auth_bloc.dart';
import 'package:warehouse_manager/features/items/data/repositories/items_repository.dart';
import 'package:warehouse_manager/features/items/presentation/pages/item_form_page.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../items/presentation/pages/items_table_page.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Page'),
      ),
      body: Center(
        child: Column(
          children: [

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text('Login'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemsListPage()));
              },
              child: const Text('Items'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666', 'Cancel', true, ScanMode.BARCODE);

                var itemResult = await context.read<ItemsRepository>().fetchItemByCode(barcodeScanRes);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemFormPage(item: itemResult)));
              },
              child: const Text('Scan item code'),
            ),

          ],
        ),
      ),
    );
  }
}
