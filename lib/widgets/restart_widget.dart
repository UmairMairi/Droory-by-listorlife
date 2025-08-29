import 'package:flutter/material.dart';

/// A widget that enables programmatic app restarts by rebuilding the widget subtree.
/// Wrap your `MaterialApp` or root widget with `RestartWidget`.
///
/// To restart the app:
/// ```dart
/// RestartWidget.restartApp(context);
/// ```
class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({super.key, required this.child});

  @override
  State<RestartWidget> createState() => _RestartWidgetState();

  /// Call this method to restart the app by changing the widget tree key.
  static void restartApp(BuildContext context) {
    final state = context.findAncestorStateOfType<_RestartWidgetState>();
    if (state == null) {
      debugPrint('RestartWidget: No ancestor state found to restart.');
    } else {
      state.restartApp();
    }
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  /// Triggers the app restart by assigning a new unique key,
  /// which forces a rebuild of the entire subtree.
  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
