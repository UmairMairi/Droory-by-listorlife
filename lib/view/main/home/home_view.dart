import 'package:flutter/material.dart';
import 'package:list_and_life/animations/bouncing_animation.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: BouncingAnimation(
        child: Icon(
          Icons.add_a_photo,
          size: 120,
        ),
      ),
    );
  }
}
