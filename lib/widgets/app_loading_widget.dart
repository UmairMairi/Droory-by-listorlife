import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // <--- 1. Change the import

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // 2. Replace the SpinKit with Lottie
      child: Lottie.asset(
        'assets/animations/Animation2.json', // <-- 3. IMPORTANT: Change this to your file's name
        width: 150,
        height: 150,
      ),
    );
  }
}
