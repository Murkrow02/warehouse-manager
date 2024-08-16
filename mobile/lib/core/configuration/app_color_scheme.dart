import 'package:flutter/material.dart';

class AppTheme {
  static ColorScheme getDefaultColorScheme() {
    return const ColorScheme(
      // Main colors
      primary: Color(0xFF1E88E5),      // A professional blue for primary
      secondary: Color(0xFF42A5F5),    // A lighter blue for secondary

      // Background color
      surface: Color(0xFFF5F5F5),      // A light gray for surface

      // Error color
      error: Color(0xFFD32F2F),        // A strong red for errors

      // Text and icon colors on primary color
      onPrimary: Colors.white,         // White text/icons on primary color

      // Text and icon colors on secondary color
      onSecondary: Colors.white,       // White text/icons on secondary color

      // Text and icon colors on surface color
      onSurface: Color(0xFF001F3A),    // Blue text/icons on surface color

      // Text and icon colors on error color
      onError: Colors.white,           // White text/icons on error color

      // Specify the brightness
      brightness: Brightness.light,    // Light theme
    );
  }
}
