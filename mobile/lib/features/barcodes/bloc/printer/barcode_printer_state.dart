import 'package:equatable/equatable.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import '../../../../core/models/traced_error.dart';

abstract class BarcodePrinterState extends Equatable {
  const BarcodePrinterState();

  @override
  List<Object> get props => [];
}

class PrinterInitial extends BarcodePrinterState {}

class PrinterScanning extends BarcodePrinterState {}

class PrintersFound extends BarcodePrinterState {
  final List<Printer> printers;

  const PrintersFound(this.printers);

  @override
  List<Object> get props => [printers];
}

class PrinterConnecting extends BarcodePrinterState {
  final Printer printer;

  const PrinterConnecting(this.printer);

  @override
  List<Object> get props => [printer];
}

class PrinterConnected extends BarcodePrinterState {
  final Printer printer;

  const PrinterConnected(this.printer);

  @override
  List<Object> get props => [printer];
}

class PrinterError extends BarcodePrinterState {
  final String message;

  const PrinterError(this.message);

  @override
  List<Object> get props => [message];
}

class PrintingSuccess extends BarcodePrinterState {}

class PrintingError extends BarcodePrinterState {
  final TracedError error;

  const PrintingError({required this.error});

  @override
  List<Object> get props => [error];
}
