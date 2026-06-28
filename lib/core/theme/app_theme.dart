import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

abstract class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.displayLarge,
          headlineMedium: AppTextStyles.headlineMedium,
          titleLarge: AppTextStyles.titleLarge,
          titleMedium: AppTextStyles.titleMedium,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.labelLarge,
          labelSmall: AppTextStyles.labelSmall,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          centerTitle: true,
          titleTextStyle: AppTextStyles.titleLarge,
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: AppTextStyles.labelLarge.copyWith(color: Colors.white),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: AppTextStyles.labelLarge,
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(foregroundColor: AppColors.textPrimary),
        ),
        dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 0.5),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.inputFill,
          selectedColor: AppColors.primary.withValues(alpha: 0.15),
          labelStyle: AppTextStyles.bodySmall,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: AppColors.border, width: 0.5),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primaryLight,
          secondary: AppColors.secondary,
          surface: AppColors.darkSurface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.darkTextPrimary),
          headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.darkTextPrimary),
          titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.darkTextPrimary),
          titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.darkTextPrimary),
          bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkTextPrimary),
          bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkTextPrimary),
          bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.darkTextSecondary),
          labelLarge: AppTextStyles.labelLarge,
          labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.darkTextSecondary),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkTextPrimary,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.darkBorder, width: 0.5),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkInputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
          ),
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkTextSecondary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        dividerTheme: const DividerThemeData(color: AppColors.darkBorder, thickness: 0.5),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.darkCard,
          contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkTextPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.darkInputFill,
          selectedColor: AppColors.primary.withValues(alpha: 0.3),
          labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.darkTextPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: AppColors.darkBorder, width: 0.5),
        ),
      );
}
