import 'package:flutter/material.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';

class LikeButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isFav;
  final Color? color;

  const LikeButton(
      {super.key, required this.onTap, required this.isFav, this.color});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  bool _isFavorite = false;

  @override
  void initState() {
    _isFavorite = widget.isFav;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        // Only toggle the heart if user is logged in
        if (!DbHelper.getIsGuest()) {
          setState(() {
            _isFavorite = !_isFavorite;
          });
          _controller.reverse().then((value) => _controller.forward());
        }
      },
      child: ScaleTransition(
        scale: Tween(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: Padding(
            padding: EdgeInsets.all(5),
            child: _isFavorite
                ? const Icon(
                    Icons.favorite,
                    size: 30,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.favorite_border_outlined,
                    size: 30,
                    color: widget.color ?? const Color.fromARGB(255, 6, 5, 5),
                  )),
      ),
    );
  }
}
