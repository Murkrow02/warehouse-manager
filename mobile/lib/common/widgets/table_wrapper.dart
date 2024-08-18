import 'package:flutter/material.dart';

class TableWrapper extends StatelessWidget {
  final Widget child;

  const TableWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    ),
    );
  }}
