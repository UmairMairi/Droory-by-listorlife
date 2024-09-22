import 'package:flutter/material.dart';

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({super.key, required this.child});

  @override
  _RestartWidgetState createState() => _RestartWidgetState();

  // Call this method to restart the app
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  // This method triggers the app restart by changing the key
  void restartApp() {
    setState(() {
      key = UniqueKey(); // Change the key to force the widget to rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
