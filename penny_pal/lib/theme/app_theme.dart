import 'package:flutter/material.dart';

class PennyColors extends ThemeExtension<PennyColors> {
  final LinearGradient goldGradient;
  final Color goldText;
  final Color periwinkle;
  final Color periwinkleMuted;
  final Color incomeMint;
  final Color warningBg;
  final Color warningText;
  final Color warningBorder;
  final Color errorRed;

  const PennyColors({
    required this.goldGradient,
    required this.goldText,
    required this.periwinkle,
    required this.periwinkleMuted,
    required this.incomeMint,
    required this.warningBg,
    required this.warningText,
    required this.warningBorder,
    required this.errorRed,
  });

  @override
  ThemeExtension<PennyColors> copyWith({
    LinearGradient? goldGradient,
    Color? goldText,
    Color? periwinkle,
    Color? periwinkleMuted,
    Color? incomeMint,
    Color? warningBg,
    Color? warningText,
    Color? warningBorder,
    Color? errorRed,
  }) {
    return PennyColors(
      goldGradient: goldGradient ?? this.goldGradient,
      goldText: goldText ?? this.goldText,
      periwinkle: periwinkle ?? this.periwinkle,
      periwinkleMuted: periwinkleMuted ?? this.periwinkleMuted,
      incomeMint: incomeMint ?? this.incomeMint,
      warningBg: warningBg ?? this.warningBg,
      warningText: warningText ?? this.warningText,
      warningBorder: warningBorder ?? this.warningBorder,
      errorRed: errorRed ?? this.errorRed,
    );
  }

  @override
  ThemeExtension<PennyColors> lerp(ThemeExtension<PennyColors>? other, double t) {
    if (other is! PennyColors) return this;
    return PennyColors(
      goldGradient: LinearGradient.lerp(goldGradient, other.goldGradient, t)!,
      goldText: Color.lerp(goldText, other.goldText, t)!,
      periwinkle: Color.lerp(periwinkle, other.periwinkle, t)!,
      periwinkleMuted: Color.lerp(periwinkleMuted, other.periwinkleMuted, t)!,
      incomeMint: Color.lerp(incomeMint, other.incomeMint, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
      warningBorder: Color.lerp(warningBorder, other.warningBorder, t)!,
      errorRed: Color.lerp(errorRed, other.errorRed, t)!,
    );
  }
}

class AppDarkTheme {
  // Common Colors
  static const Color primaryGold = Color(0xFFF3D58A);
  static const Color onPrimaryGold = Color(0xFF1A1405);
  static const Color periwinkle = Color(0xFF8EA2FF);
  
  static final PennyColors darkPennyColors = PennyColors(
    goldGradient: const LinearGradient(
      colors: [Color(0xFFF7E2A6), Color(0xFFE5AE5A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    goldText: onPrimaryGold,
    periwinkle: periwinkle,
    periwinkleMuted: periwinkle.withValues(alpha: 0.3),
    incomeMint: const Color(0xFF6EE7B7),
    warningBg: const Color(0xFFFFAB5E).withValues(alpha: 0.12),
    warningText: const Color(0xFFFFC48A),
    warningBorder: const Color(0xFFFFAB5E).withValues(alpha: 0.25),
    errorRed: const Color(0xFFFF9B85),
  );

  static ThemeData get darkTheme {
    const Color scaffoldBg = Color(0xFF060A1E);
    const Color surfaceColor = Color(0xFF0F1533);
    const Color onSurface = Color(0xFFEEF0FA);
    const Color mutedText = Color(0xFF98A2C9);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: const ColorScheme.dark(
        primary: primaryGold,
        onPrimary: onPrimaryGold,
        secondary: periwinkle,
        surface: surfaceColor,
        onSurface: onSurface,
        outline: Colors.white, // Will use withValues(alpha: 0.08 / 0.12)
        error: Color(0xFFFF9B85),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: onSurface),
        bodyMedium: TextStyle(color: onSurface),
        bodySmall: TextStyle(color: mutedText),
      ),
      extensions: [darkPennyColors],
      
      // Component Themes
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Colors.white10, width: 1), // White 8% approximation
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          // Gradient is handled manually in widget tree usually, but we set solid fallback
          backgroundColor: primaryGold,
          foregroundColor: onPrimaryGold,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: primaryGold,
          foregroundColor: onPrimaryGold,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          foregroundColor: onSurface,
          side: const BorderSide(color: Colors.white24, width: 1), // White 16%
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryGold, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF0A1029).withValues(alpha: 0.85),
        indicatorColor: primaryGold.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryGold);
          }
          return IconThemeData(color: mutedText);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: primaryGold, fontSize: 12, fontWeight: FontWeight.w600);
          }
          return TextStyle(color: mutedText, fontSize: 12, fontWeight: FontWeight.w500);
        }),
      ),
    );
  }
}
