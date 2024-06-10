import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colors => theme.colorScheme;
  TextStyle? get displayLarge => textTheme.displayLarge?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get displayMedium => textTheme.displayMedium?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get displaySmall => textTheme.displaySmall?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get headlineLarge => textTheme.headlineLarge?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get headlineMedium => textTheme.headlineMedium?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get headlineSmall => textTheme.headlineSmall?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get titleLarge => textTheme.titleLarge?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get titleMedium => textTheme.titleMedium?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get titleSmall => textTheme.titleSmall?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get labelLarge => textTheme.labelLarge?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get labelMedium => textTheme.labelMedium?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get labelSmall => textTheme.labelSmall?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get bodyLarge => textTheme.bodyLarge?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get bodyMedium => textTheme.bodyMedium?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get bodySmall => textTheme.bodySmall?.copyWith(
        color: colors.onSurface,
      );

  // Get the screen height
  double get height => MediaQuery.of(this).size.height;

  // Get the screen width
  double get width => MediaQuery.of(this).size.width;
  bool get isMobile => MediaQuery.of(this).size.width < 500;
  bool get isTablet => MediaQuery.of(this).size.width >= 500;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1100;

  // Get the screen orientation
  Orientation get orientation => MediaQuery.of(this).orientation;

  // Get the device pixel ratio
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  // Check if the screen is in landscape orientation
  bool get isLandscape => orientation == Orientation.landscape;

  // Check if the screen is in portrait orientation
  bool get isPortrait => orientation == Orientation.portrait;

  // Get the safe area padding (e.g., for notched devices)
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  // Get the viewInsets (e.g., for handling keyboard overlay)
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  bool get isWeb => kIsWeb;
  bool get isAndroid => Theme.of(this).platform == TargetPlatform.android;
  bool get isIos => Theme.of(this).platform == TargetPlatform.iOS;
}
