import 'package:flutter/material.dart';

class RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    print('Going to ${route.settings.name} page');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    print('Going back from ${route.settings.name} page');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print(
        'Replacing ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    print('Removing ${route.settings.name} page');
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    print('User started gesture on ${route.settings.name} page');
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    print('User stopped gesture');
  }
}
