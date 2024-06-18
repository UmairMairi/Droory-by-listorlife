import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitFadingCircle(
        color: Color(0xFF000000),
        size: 50.0,
      ),
    );
  }
}
