import 'package:flutter/material.dart';

class FormWrapper extends StatelessWidget {

  FormWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {

    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth > 1000 ? 1000 : screenWidth;

    return Center(
      child: SizedBox(
        width: formWidth,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 7,
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}