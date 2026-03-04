import 'package:flutter/material.dart';

class AppColors {
  // ── Backgrounds ──────────────────────────────
  static const Color background     = Color(0xFF111211); // dark charcoal-black
  static const Color surface        = Color(0xFF1A1C19); // card surface
  static const Color surfaceVariant = Color(0xFF222420); // input fields, chips

  // ── Accent ───────────────────────────────────
  static const Color accent         = Color(0xFF5BAD8F); // muted sage-teal
  static const Color accentLight    = Color(0xFF7EC4A8); // hover / highlight state
  static const Color accentDark     = Color(0xFF3D8A6E); // pressed state

  // ── Text ─────────────────────────────────────
  static const Color textPrimary    = Color(0xFFF5F0E8); // warm off-white
  static const Color textSecondary  = Color(0xFFB8A898); // muted warm grey
  static const Color textHint       = Color(0xFF7A6A5A); // placeholder text

  // ── UI Elements ──────────────────────────────
  static const Color divider        = Color(0xFF222420);
  static const Color border         = Color(0xFF2A2D2A);
  static const Color error          = Color(0xFFCF6679);
  static const Color success        = Color(0xFF5BAD8F);
  static const Color warning        = Color(0xFFD4A857);

  // ── Bottom Nav ───────────────────────────────
  static const Color navBackground  = Color(0xFF0E100E);
  static const Color navSelected    = Color(0xFF5BAD8F);
  static const Color navUnselected  = Color(0xFF7A6A5A);
}

class AppTypography {
  static const String fontFamily = 'Outfit';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTypography.fontFamily,

      // ── Color Scheme ───────────────────────────
      colorScheme: const ColorScheme.dark(
        surface:          AppColors.surface,
        primary:          AppColors.accent,
        primaryContainer: AppColors.accentDark,
        secondary:        AppColors.accentLight,
        error:            AppColors.error,
        onSurface:        AppColors.textPrimary,
        onPrimary:        AppColors.background,
        onSecondary:      AppColors.background,
        onError:          AppColors.textPrimary,
        outline:          AppColors.border,
      ),

      scaffoldBackgroundColor: AppColors.background,

      // ── AppBar ─────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor:        AppColors.background,
        elevation:              0,
        scrolledUnderElevation: 0,
        centerTitle:            false,
        titleTextStyle:         AppTypography.headlineMedium,
        iconTheme:              IconThemeData(color: AppColors.textPrimary),
      ),

      // ── Bottom Navigation Bar ──────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor:      AppColors.navBackground,
        selectedItemColor:    AppColors.navSelected,
        unselectedItemColor:  AppColors.navUnselected,
        type:                 BottomNavigationBarType.fixed,
        elevation:            0,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: AppTypography.fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          fontFamily: AppTypography.fontFamily,
        ),
      ),

      // ── Elevated Button ────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          minimumSize:     const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.labelLarge,
          elevation:  0,
        ),
      ),

      // ── Outlined Button ────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          minimumSize:     const Size(double.infinity, 50),
          side: const BorderSide(color: AppColors.accent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ── Text Button ────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle:       AppTypography.labelLarge,
        ),
      ),

      // ── Input Fields ───────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:      true,
        fillColor:   AppColors.surfaceVariant,
        hintStyle:   AppTypography.bodyMedium.copyWith(
          color: AppColors.textHint,
        ),
        labelStyle:       AppTypography.bodyMedium,
        prefixIconColor:  AppColors.textSecondary,
        suffixIconColor:  AppColors.textSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
      ),

      // ── Card ───────────────────────────────────
      cardTheme: CardThemeData(
        color:        AppColors.surface,
        elevation:    0,
        clipBehavior: Clip.antiAlias,
      ),

      // ── Chip ───────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor:     AppColors.surfaceVariant,
        selectedColor:       AppColors.accent,
        labelStyle:          AppTypography.labelSmall.copyWith(
          color: AppColors.textSecondary,
        ),
        secondaryLabelStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.background,
        ),
        side: const BorderSide(color: AppColors.border, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── Divider ────────────────────────────────
      dividerTheme: const DividerThemeData(
        color:     AppColors.divider,
        thickness: 1,
        space:     1,
      ),

      // ── Icon ───────────────────────────────────
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size:  24,
      ),

      // ── Text Theme ─────────────────────────────
      textTheme: const TextTheme(
        displayLarge:   AppTypography.displayLarge,
        displayMedium:  AppTypography.displayMedium,
        headlineLarge:  AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        titleLarge:     AppTypography.titleLarge,
        titleMedium:    AppTypography.titleMedium,
        bodyLarge:      AppTypography.bodyLarge,
        bodyMedium:     AppTypography.bodyMedium,
        bodySmall:      AppTypography.bodySmall,
        labelLarge:     AppTypography.labelLarge,
        labelSmall:     AppTypography.labelSmall,
      ),

      // ── Snack Bar ──────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceVariant,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Progress Indicator ─────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color:            AppColors.accent,
        linearTrackColor: AppColors.surfaceVariant,
      ),
    );
  }
}