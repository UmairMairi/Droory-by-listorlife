import 'package:flutter/material.dart';
import 'dart:math' as math;

class SwingAnimation extends StatefulWidget {
  final Widget child;
  const SwingAnimation({super.key, required this.child});

  @override
  State<SwingAnimation> createState() => _SwingAnimationState();
}

class _SwingAnimationState extends State<SwingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final double amplitude = 20.0; // Adjust the amplitude of the swing
  final double frequency = 1.5; // Adjust the frequency of the swing

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateOffset(double animationValue) {
    // Calculate the offset using a sine wave function
    return math.sin(animationValue * 2 * math.pi * frequency) * amplitude;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double offset = _calculateOffset(_controller.value);
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: child,
                );
              },
              child: widget.child, // Replace with your image path
            ),
          ),
        ],
      ),
    );
  }
}
