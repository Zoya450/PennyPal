import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── PennyColors ThemeExtension ────────────────────────────────────────────
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
  final Color mutedText;
  final Color sidebarBg;

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
    required this.mutedText,
    required this.sidebarBg,
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
    Color? mutedText,
    Color? sidebarBg,
  }) =>
      PennyColors(
        goldGradient: goldGradient ?? this.goldGradient,
        goldText: goldText ?? this.goldText,
        periwinkle: periwinkle ?? this.periwinkle,
        periwinkleMuted: periwinkleMuted ?? this.periwinkleMuted,
        incomeMint: incomeMint ?? this.incomeMint,
        warningBg: warningBg ?? this.warningBg,
        warningText: warningText ?? this.warningText,
        warningBorder: warningBorder ?? this.warningBorder,
        errorRed: errorRed ?? this.errorRed,
        mutedText: mutedText ?? this.mutedText,
        sidebarBg: sidebarBg ?? this.sidebarBg,
      );

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
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      sidebarBg: Color.lerp(sidebarBg, other.sidebarBg, t)!,
    );
  }
}

// ─── AppTheme ───────────────────────────────────────────────────────────────
class AppTheme {
  // ── Light palette ─────────────────────────────────────────────────────────
  static const Color lightBg = Color(0xFFFCF1D0);
  static const Color lightCard = Color(0xFFFCF1D0);
  static const Color lightBorder = Color(0xFFF0E3BC);
  static const Color lightText = Color(0xFF0D1C42);
  static const Color lightMutedText = Color(0xFF4A5680);
  static const Color lightPrimary = Color(0xFF22396F);
  static const Color lightCream = Color(0xFFFCF1D0);

  // ── Dark palette (Midnight + Penny Gold) ──────────────────────────────────
  static const Color darkScaffold = Color(0xFF060A1E);
  static const Color darkSurface = Color(0xFF0F1533);
  static const Color darkSidebar = Color(0xFF0A1029);
  static const Color darkOnSurface = Color(0xFFEEF0FA);
  static const Color darkMuted = Color(0xFF98A2C9);
  static const Color darkGold = Color(0xFFF3D58A);
  static const Color darkGoldText = Color(0xFF1A1405);
  static const Color darkPeriwinkle = Color(0xFF8EA2FF);
  static const Color darkMint = Color(0xFF6EE7B7);
  static const Color darkError = Color(0xFFFF9B85);
  static const Color darkWarning = Color(0xFFFFAB5E);

  static final PennyColors _lightPennyColors = PennyColors(
    goldGradient: const LinearGradient(colors: [Color(0xFF22396F), Color(0xFF22396F)]),
    goldText: lightCream,
    periwinkle: const Color(0xFF4A5680),
    periwinkleMuted: const Color(0xFF4A5680).withValues(alpha: 0.3),
    incomeMint: const Color(0xFF1A7A4A),
    warningBg: const Color(0xFFFBE9D5),
    warningText: const Color(0xFF7A3A10),
    warningBorder: const Color(0xFFF3C68A).withValues(alpha: 0.6),
    errorRed: const Color(0xFFB00020),
    mutedText: lightMutedText,
    sidebarBg: lightCard,
  );

  static final PennyColors _darkPennyColors = PennyColors(
    goldGradient: const LinearGradient(
      colors: [Color(0xFFF7E2A6), Color(0xFFE5AE5A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    goldText: darkGoldText,
    periwinkle: darkPeriwinkle,
    periwinkleMuted: darkPeriwinkle.withValues(alpha: 0.3),
    incomeMint: darkMint,
    warningBg: darkWarning.withValues(alpha: 0.12),
    warningText: const Color(0xFFFFC48A),
    warningBorder: darkWarning.withValues(alpha: 0.25),
    errorRed: darkError,
    mutedText: darkMuted,
    sidebarBg: darkSidebar.withValues(alpha: 0.85),
  );

  // ── Light Theme (unchanged) ───────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      primaryColor: lightPrimary,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        onPrimary: lightCream,
        secondary: Color(0xFF4A5680),
        surface: lightCard,
        onSurface: lightText,
        outline: lightBorder,
        error: Color(0xFFB00020),
      ),
      extensions: [_lightPennyColors],
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.light).textTheme)
          .copyWith(
            bodySmall: GoogleFonts.poppins(color: lightMutedText),
          )
          .apply(bodyColor: lightText, displayColor: lightText),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: lightCream,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: lightCream,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightText,
          side: const BorderSide(color: lightBorder, width: 1.5),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: lightBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
        hintStyle: GoogleFonts.poppins(color: lightMutedText, fontSize: 15),
      ),
    );
  }

  // ── Dark Theme (Midnight + Penny Gold) ────────────────────────────────────
  static ThemeData get darkTheme {
    // Force light status bar icons in dark mode
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkScaffold,
      primaryColor: darkGold,
      colorScheme: ColorScheme.dark(
        primary: darkGold,
        onPrimary: darkGoldText,
        secondary: darkPeriwinkle,
        onSecondary: darkGoldText,
        surface: darkSurface,
        onSurface: darkOnSurface,
        outline: Colors.white.withValues(alpha: 0.08),
        error: darkError,
        onError: darkScaffold,
      ),
      extensions: [_darkPennyColors],
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme)
          .copyWith(
            bodySmall: GoogleFonts.poppins(color: darkMuted),
          )
          .apply(bodyColor: darkOnSurface, displayColor: darkOnSurface),
      // Buttons: gold gradient feel; flat, no glow
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGold,
          foregroundColor: darkGoldText,
          shape: const StadiumBorder(),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: darkGold,
          foregroundColor: darkGoldText,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkOnSurface,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.16), width: 1),
          shape: const StadiumBorder(),
        ),
      ),
      // Cards: subtle 1px border, no elevation/shadow
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1),
        ),
      ),
      // Inputs: white 5% fill, no glow on focus
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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
          borderSide: const BorderSide(color: darkGold, width: 1.5),
        ),
        hintStyle: GoogleFonts.poppins(color: darkMuted, fontSize: 15),
      ),
      // Navigation: gold selected item, no glow indicator
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSidebar.withValues(alpha: 0.85),
        elevation: 0,
        shadowColor: Colors.transparent,
        indicatorColor: darkGold.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: darkGold);
          }
          return IconThemeData(color: darkMuted);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(color: darkGold, fontSize: 12, fontWeight: FontWeight.w600);
          }
          return GoogleFonts.poppins(color: darkMuted, fontSize: 12);
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: darkSidebar.withValues(alpha: 0.85),
        selectedIconTheme: const IconThemeData(color: darkGold),
        unselectedIconTheme: IconThemeData(color: darkMuted),
        indicatorColor: darkGold.withValues(alpha: 0.15),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.08),
      ),
      // No global dialog glow
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1),
        ),
      ),
      // Popups / bottom sheets
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 0,
      ),
    );
  }
}
