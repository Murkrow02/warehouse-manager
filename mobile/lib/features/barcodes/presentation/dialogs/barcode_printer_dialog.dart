import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_manager/common/widgets/error_alert.dart';
import 'package:warehouse_manager/common/widgets/loading.dart';

import '../../bloc/printer/barcode_printer_bloc.dart';
import '../../bloc/printer/barcode_printer_event.dart';
import '../../bloc/printer/barcode_printer_state.dart';

class BarcodePrinterDialog extends StatelessWidget {

  final String code;
  const BarcodePrinterDialog({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Barcode Printer'),
      content: BlocProvider(
        create: (context) => BarcodePrinterBloc(FlutterThermalPrinter.instance)
          ..add(LoadPrintersEvent()),
        child: BlocBuilder<BarcodePrinterBloc, BarcodePrinterState>(
          builder: (context, state) {

            // Scan for printer on load
            if (state is PrinterScanning) {
              return const Loading();
            }

            // Show list of printers
            else if (state is PrintersFound) {
              return _buildPrinterList(state.printers, context);
            }

            // By tapping on a printer, connect to it
            else if (state is PrinterConnecting) {
              var printerName = state.printer.name ?? 'printer';
              return Center(
                  child: Column(
                children: [
                  Text('Connecting to: $printerName'),
                  const Loading(),
                ],
              ));
            }

            // We are connected to the printer, show print button
            else if (state is PrinterConnected) {
              return _buildPrintingPreview(context, state.printer);
            }

            // Error occurred
            else if (state is PrintingError) {
              return ErrorAlert(state.error);
            }

            // Printing successful
            else if (state is PrintingSuccess) {
              return const Center(child: Text('Printing successful'));
            } else {
              return const Text('Unknown state');
            }
          },
        ),
      ),
    );
  }


  Widget _buildPrinterList(List<Printer> printers, BuildContext context) {
    // Create a column with a list of printers
    return Column(
      children: printers.map((printer) {
        return ListTile(
          title: Text(printer.name ?? 'Unknown'),
          subtitle: Text(printer.address ?? 'Unknown'),
          onTap: () {
            // Connect to the printer
            BlocProvider.of<BarcodePrinterBloc>(context)
                .add(ConnectToPrinterEvent(printer));
          },
        );
      }).toList(),
    );
  }

  Widget _buildPrintingPreview(BuildContext context, Printer printer) {
    return ElevatedButton(
      onPressed: () {
        // Print the receipt
        BlocProvider.of<BarcodePrinterBloc>(context)
            .add(PrintReceiptEvent(printer, code));
      },
      child: const Text('Print'),
    );
  }

}
