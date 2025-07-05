// import 'package:blog_app/core/theme/app_pallete.dart';
// import 'package:flutter/material.dart';

// class AppTheme {
//   static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
//         borderSide: BorderSide(
//           color: color,
//           width: 3,
//         ),
//         borderRadius: BorderRadius.circular(10),
//       );
//   static final darkThemeMode = ThemeData.dark().copyWith(
//     scaffoldBackgroundColor: AppPallete.backgroundColor,
//     appBarTheme:  AppBarTheme(
//       backgroundColor: AppPallete.backgroundColor,
//     ),
//     chipTheme:  ChipThemeData(
//       color: WidgetStatePropertyAll(
//         AppPallete.backgroundColor,
//       ),
//       side: BorderSide.none,
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       contentPadding: const EdgeInsets.all(27),
//       border: _border(),
//       enabledBorder: _border(),
//       focusedBorder: _border(AppPallete.gradient2),
//       errorBorder: _border(AppPallete.errorColor),
//     ),
//   );
// }
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static ThemeData get darkThemeMode => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppPallete.backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppPallete.backgroundColor,
        ),
        chipTheme: ChipThemeData(
          color: WidgetStatePropertyAll(
            AppPallete.backgroundColor,
          ),
          side: BorderSide.none,
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          border: _border(AppPallete.borderColor),
          enabledBorder: _border(AppPallete.borderColor),
          focusedBorder: _border(AppPallete.gradient2),
          errorBorder: _border(AppPallete.errorColor),
        ),
      );
}
