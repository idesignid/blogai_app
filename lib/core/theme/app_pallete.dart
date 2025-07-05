// import 'package:flutter/material.dart';

// class AppPallete {
//   static const Color backgroundColor = Color.fromRGBO(24, 24, 32, 1);
//   static const Color gradient1 = Color.fromRGBO(187, 63, 221, 1);
//   static const Color gradient2 = Color.fromRGBO(251, 109, 169, 1);
//   static const Color gradient3 = Color.fromRGBO(255, 159, 124, 1);
//   static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);
//   static const Color whiteColor = Colors.white;
//   static const Color greyColor = Colors.grey;
//   static const Color errorColor = Colors.redAccent;
//   static const Color transparentColor = Colors.transparent;
// }

// lib/core/theme/app_palette.dart
// lib/core/theme/app_pallete.dart
// lib/core/theme/app_pallete.dart

// lib/core/theme/app_pallete.dart

import 'package:flutter/material.dart';

/// Centralized palette with dynamic theme toggling.
/// Class name and API exactly match your existing calls.
class AppPallete {
  /// true = light mode, false = dark mode.
  static bool isLight = false;

  /// Call this (inside setState) to flip the theme.
  static void toggleTheme() {
    isLight = !isLight;
  }

  /// Scaffold/background
  static Color get backgroundColor =>
      isLight ? const Color(0xFFFAFAFA) : const Color(0xFF1E1E2F);

  /// Primary gradients (same stops both themes)
  static Color get gradient1 => const Color(0xFF6EA8DC); // soft sky blue
  static Color get gradient2 => const Color(0xFF8EC5FC); // pastel azure
  static Color get gradient3 => const Color(0xFFE0C3FC); // gentle lavender

  /// Borders for cards, inputs, etc.
  static Color get borderColor =>
      isLight ? const Color(0xFFE0E0E0) : const Color(0xFF2E2E3F);

  /// Primary on‑background text/icon
  static Color get whiteColor => isLight ? Colors.black87 : Colors.white;

  /// Secondary text/icon (muted)
  static Color get greyColor =>
      isLight ? const Color(0xFF757575) : const Color(0xFFA0A0A0);

  /// Softer error tone
  static Color get errorColor => const Color(0xFFE57373);

  /// Always transparent
  static const Color transparentColor = Colors.transparent;
}
