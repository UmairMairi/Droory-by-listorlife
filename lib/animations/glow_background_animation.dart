import 'package:flutter/material.dart';

class GlowBackgroundAnimation extends StatefulWidget {
  final ImageProvider image;

  const GlowBackgroundAnimation({required this.image, super.key});

  @override
  State<GlowBackgroundAnimation> createState() => _GlowAvatarAnimationState();
}

class _GlowAvatarAnimationState extends State<GlowBackgroundAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 10).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: GlowPainter(_animation.value),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: widget.image,
              radius: 30,
            ),
          ),
        );
      },
    );
  }
}

class GlowPainter extends CustomPainter {
  final double glowRadius;

  GlowPainter(this.glowRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
