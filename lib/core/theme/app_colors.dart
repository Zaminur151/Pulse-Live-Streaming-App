import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFC0C1FF);
  static const Color onPrimary = Color(0xFF1000A9);
  static const Color primaryContainer = Color(0xFF8083FF);
  static const Color onPrimaryContainer = Color(0xFF0D0096);

  static const Color secondary = Color(0xFF7BD0FF);
  static const Color onSecondary = Color(0xFF00354A);
  static const Color secondaryContainer = Color(0xFF00A6E0);
  static const Color onSecondaryContainer = Color(0xFF00374D);

  static const Color tertiary = Color(0xFFFFB3AD);
  static const Color onTertiary = Color(0xFF68000A);
  static const Color tertiaryContainer = Color(0xFFFF5451);
  static const Color onTertiaryContainer = Color(0xFF5C0008);

  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  static const Color background = Color(0xFF10131A);
  static const Color onBackground = Color(0xFFE1E2EB);

  static const Color surface = Color(0xFF10131A);
  static const Color surfaceDim = Color(0xFF10131A);
  static const Color surfaceBright = Color(0xFF363940);
  
  static const Color surfaceContainerLowest = Color(0xFF0B0E14);
  static const Color surfaceContainerLow = Color(0xFF191C22);
  static const Color surfaceContainer = Color(0xFF1D2026);
  static const Color surfaceContainerHigh = Color(0xFF272A31);
  static const Color surfaceContainerHighest = Color(0xFF32353C);

  static const Color onSurface = Color(0xFFE1E2EB);
  static const Color onSurfaceVariant = Color(0xFFC7C4D7);
  static const Color outline = Color(0xFF908FA0);
  static const Color outlineVariant = Color(0xFF464554);
  
  // Custom Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF38BDF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
