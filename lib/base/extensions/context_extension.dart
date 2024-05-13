import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

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
