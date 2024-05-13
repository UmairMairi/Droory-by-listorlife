import 'dart:async';
import 'package:flutter/material.dart';

class AppResendOtpButton extends StatefulWidget {
  final int seconds;
  final Function() onResend;

  const AppResendOtpButton({
    super.key,
    required this.seconds,
    required this.onResend,
  });

  @override
  _AppResendOtpButtonState createState() => _AppResendOtpButtonState();
}

class _AppResendOtpButtonState extends State<AppResendOtpButton> {
  late Timer _timer;
  int _countdown = 0;

  @override
  void initState() {
    _countdown = widget.seconds;
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _cancelTimer();
        }
      });
    });
  }

  void _cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void _handleResend() {
    widget.onResend();
    _countdown = widget.seconds;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _countdown == 0 ? _handleResend : null,
      child: Text(
        _countdown == 0 ? "Resend" : "Resend OTP ($_countdown)",
        style: TextStyle(
          color: _countdown == 0 ? Colors.red : Colors.grey,
          fontWeight: FontWeight.w800,
          decorationColor: Colors.red,
          decoration:
              _countdown == 0 ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}
