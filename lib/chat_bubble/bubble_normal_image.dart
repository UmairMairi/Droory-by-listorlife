import 'package:flutter/material.dart';

const double BUBBLE_RADIUS_IMAGE = 16;

class BubbleNormalImage extends StatelessWidget {
  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  final String id;
  final Widget image;
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool timeStamp;
  final String? createdAt;

  const BubbleNormalImage({
    super.key,
    required this.id,
    required this.image,
    this.timeStamp = false,
    this.createdAt,
    this.bubbleRadius = BUBBLE_RADIUS_IMAGE,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    this.leading,
    this.trailing,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.onTap,
    this.onLongPress,
  });

  /// image bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Widget? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    if (timeStamp) {
      stateTick = true;
      stateIcon = Text(
        createdAt ?? '',
        style: const TextStyle(
          fontSize: 10,
          color: Colors.black54,
        ),
      );
    }

    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : leading ?? Container(),
        Container(
          padding: padding,
          margin: margin,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .5,
            maxHeight: MediaQuery.of(context).size.width * .5,
          ),
          child: GestureDetector(
              onLongPress: onLongPress,
              onTap: onTap ??
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return _DetailScreen(
                        tag: id,
                        image: image,
                      );
                    }));
                  },
              child: Hero(
                tag: id,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(bubbleRadius),
                          topRight: Radius.circular(bubbleRadius),
                          bottomLeft: Radius.circular(tail
                              ? isSender
                                  ? bubbleRadius
                                  : 0
                              : BUBBLE_RADIUS_IMAGE),
                          bottomRight: Radius.circular(tail
                              ? isSender
                                  ? 0
                                  : bubbleRadius
                              : BUBBLE_RADIUS_IMAGE),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(bubbleRadius),
                          child: image,
                        ),
                      ),
                    ),
                    stateIcon != null && stateTick
                        ? Positioned(
                            bottom: 4,
                            right: 6,
                            child: stateIcon,
                          )
                        : const SizedBox(
                            width: 1,
                          ),
                  ],
                ),
              )),
        ),
        if (isSender && trailing != null) const SizedBox.shrink(),
      ],
    );
  }
}

/// detail screen of the image, display when tap on the image bubble
class _DetailScreen extends StatefulWidget {
  final String tag;
  final Widget image;

  const _DetailScreen({required this.tag, required this.image});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

/// created using the Hero Widget
class _DetailScreenState extends State<_DetailScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: widget.tag,
            child: widget.image,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
