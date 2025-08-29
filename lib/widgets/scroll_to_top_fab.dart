import 'package:flutter/material.dart';

/// Watches [controller], fades in after you scroll past [threshold],
/// and scrolls back to zero when tapped. On hover the arrow lifts.
class ScrollToTopFAB extends StatefulWidget {
  final ScrollController controller;
  final double threshold;
  final Duration fadeDuration;
  final Duration scrollDuration;
  final Curve scrollCurve;

  const ScrollToTopFAB({
    Key? key,
    required this.controller,
    this.threshold = 400.0,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.scrollDuration = const Duration(milliseconds: 500),
    this.scrollCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  _ScrollToTopFABState createState() => _ScrollToTopFABState();
}

class _ScrollToTopFABState extends State<ScrollToTopFAB> {
  bool _visible = false;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  void _onScroll() {
    final isPast = widget.controller.offset > widget.threshold;
    if (isPast != _visible) {
      setState(() => _visible = isPast);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !_visible,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: widget.fadeDuration,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(0, _hovering ? -4 : 0, 0),
            child: FloatingActionButton(
              mini: true,
              elevation: 4,
              backgroundColor: Colors.grey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // ← more rounded
              ),
              onPressed: () => widget.controller.animateTo(
                0,
                duration: widget.scrollDuration,
                curve: widget.scrollCurve,
              ),
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
