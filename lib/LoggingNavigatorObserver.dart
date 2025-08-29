import 'package:flutter/material.dart';

class LoggingNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> _routeStack = [];

  void _printStack() {
    debugPrint('----- Navigation Stack -----');
    for (var route in _routeStack) {
      debugPrint(route.settings.name ?? route.toString());
    }
    debugPrint('---------------------------');
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _routeStack.add(route);
    _printStack();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _routeStack.remove(route);
    _printStack();
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _routeStack.remove(route);
    _printStack();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    int index = _routeStack.indexOf(oldRoute!);
    if (index != -1 && newRoute != null) {
      _routeStack[index] = newRoute;
    }
    _printStack();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
