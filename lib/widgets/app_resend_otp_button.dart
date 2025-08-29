import 'dart:async';
import 'package:flutter/material.dart';
// Adjust paths as needed for your project:
import '../../base/helpers/string_helper.dart';
import '../../res/font_res.dart'; // <--- Import FontRes

class AppResendOtpButton extends StatefulWidget {
  final int seconds;
  final Function() onResend;

  const AppResendOtpButton({
    super.key,
    required this.seconds,
    required this.onResend,
  });

  @override
  State<AppResendOtpButton> createState() => _AppResendOtpButtonState();
}

class _AppResendOtpButtonState extends State<AppResendOtpButton> {
  late Timer _timer;
  int _countdown = 0;

  @override
  void initState() {
    super.initState();
    _countdown = widget.seconds;
    _startTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    _timer.cancel();
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
        // If countdown is zero, show the localized “Resend.”
        // Otherwise, show the localized “Resend code in” plus countdown.
        _countdown == 0
            ? StringHelper.resend
            : '${StringHelper.resendCodeIn} ($_countdown)',
        style: const TextStyle(
          fontFamily:
              FontRes.MONTSERRAT_BOLD, // <--- Use a specific FontRes constant
          fontSize: 18,
          fontWeight: FontWeight.w800,
          decorationColor: Colors.red,
        ).copyWith(
          color: _countdown == 0 ? Colors.red : Colors.grey,
        ),
      ),
    );
  }
}
