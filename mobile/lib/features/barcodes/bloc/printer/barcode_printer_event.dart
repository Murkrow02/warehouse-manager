import 'package:equatable/equatable.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

abstract class BarcodePrinterEvent extends Equatable {
  const BarcodePrinterEvent();

  @override
  List<Object> get props => [];
}

class LoadPrintersEvent extends BarcodePrinterEvent {}

class PrintReceiptEvent extends BarcodePrinterEvent {
  final Printer printer;
  final String code;

  const PrintReceiptEvent(this.printer, this.code);

  @override
  List<Object> get props => [printer, code];
}

class ConnectToPrinterEvent extends BarcodePrinterEvent {
  final Printer printer;

  const ConnectToPrinterEvent(this.printer);

  @override
  List<Object> get props => [printer];
}
