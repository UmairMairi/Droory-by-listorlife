import 'dart:async';

import 'package:flutter/material.dart';

import '../base/base.dart';

class AppTimerScreen extends StatefulWidget {
  final int minutes;
  final VoidCallback onComplete;
  const AppTimerScreen(
      {super.key, required this.minutes, required this.onComplete});

  @override
  State<AppTimerScreen> createState() => _AppTimerScreenState();
}

class _AppTimerScreenState extends State<AppTimerScreen> {
  int remainingTimeInSeconds = 0;

  @override
  void initState() {
    remainingTimeInSeconds = widget.minutes * 60; // 120 minutes * 60 seconds
    startTimer();
    super.initState();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTimeInSeconds <= 0) {
          timer.cancel();
          widget.onComplete;
          // Optionally, you can perform actions when the timer completes.
          // For example, show a dialog or navigate to another screen.
        } else {
          remainingTimeInSeconds--;
        }
      });
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: HexColor.fromHex('#135097'),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Text(
        '${formatTime(remainingTimeInSeconds)} Min',
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}
