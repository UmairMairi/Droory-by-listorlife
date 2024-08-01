import 'dart:async';

import 'package:flutter/material.dart';

class DebounceHelper {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  DebounceHelper({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
