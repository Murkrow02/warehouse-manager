import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import 'barcode_printer_event.dart';
import 'barcode_printer_state.dart';

class BarcodePrinterBloc extends Bloc<BarcodePrinterEvent, BarcodePrinterState> {
  final FlutterThermalPrinter _flutterThermalPrinterPlugin;

  BarcodePrinterBloc(this._flutterThermalPrinterPlugin) : super(PrinterInitial()) {
    on<LoadPrintersEvent>(_onLoadPrinters);
    on<ConnectToPrinterEvent>(_onConnectToPrinter);
    on<PrintReceiptEvent>(_onPrintReceipt);
  }

  Future<void> _onLoadPrinters(
      LoadPrintersEvent event,
      Emitter<BarcodePrinterState> emit,
      ) async {
    try {
      emit(PrinterScanning());
      await _flutterThermalPrinterPlugin.getPrinters(connectionTypes: [
        ConnectionType.BLE
      ]);
      final printers = await _flutterThermalPrinterPlugin.devicesStream.first;
      emit(PrintersFound(printers));
    } catch (e) {
      emit(PrinterError(e.toString()));
    }
  }

  Future<void> _onConnectToPrinter(
      ConnectToPrinterEvent event,
      Emitter<BarcodePrinterState> emit,
      ) async {
    try {
      emit(PrinterConnecting(event.printer));
      final isConnected = await _flutterThermalPrinterPlugin.connect(event.printer);
      if (isConnected) {
        emit(PrinterConnected(event.printer));
      } else {
        emit(PrintingFailed("Failed to connect to printer"));
      }
    } catch (e) {
      emit(PrinterError(e.toString()));
    }
  }

  Future<void> _onPrintReceipt(
      PrintReceiptEvent event,
      Emitter<BarcodePrinterState> emit,
      ) async {
    try {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];
      List<int> barcodeData = event.code.split('').map(int.parse).toList();
      Barcode ean13Barcode = Barcode.ean13(barcodeData);
      bytes += generator.barcode(ean13Barcode, textPos : BarcodeText.none);
      bytes += generator.cut();
      await _flutterThermalPrinterPlugin.printData(
        event.printer,
        bytes,
        longData: true,
      );
      emit(PrintingSuccess());
    } catch (e) {
      emit(PrintingFailed("Failed to print receipt"));
    }
  }
}
