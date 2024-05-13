import 'package:flutter/material.dart';

class HeartAnimation extends StatefulWidget {
  const HeartAnimation({super.key});

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _animationController.forward(from: 0);
      } else {
        _animationController.reverse(from: 1);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Animation Example'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _toggleLike,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Icon(
                Icons.favorite,
                color: _isLiked
                    ? Colors.red
                    : Color.lerp(Colors.grey, Colors.red, _animation.value),
                size: 100 - (40 * _animation.value), // Size animation
              );
            },
          ),
        ),
      ),
    );
  }
}
