import 'package:flutter/material.dart';

const double BUBBLE_RADIUS = 16;

class BubbleNormalMessage extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final String text;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final bool timeStamp;
  final TextStyle textStyle;
  final BoxConstraints? constraints;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final String? createdAt;

  const BubbleNormalMessage({
    super.key,
    required this.text,
    this.createdAt,
    this.constraints,
    this.timeStamp = false,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    this.bubbleRadius = BUBBLE_RADIUS,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
  });

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool stateTick = false;
    Widget? stateIcon;
    Widget? timeStateIcon;

    if (sent) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done,
        size: 15,
        color: Colors.grey[600],
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 15,
        color: Colors.grey[600],
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 15,
        color: Colors.blue,
      );
    }

    if (timeStamp) {
      stateTick = true;
      timeStateIcon = Text(
        createdAt ?? '',
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey[600],
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
          color: Colors.transparent,
          constraints: constraints ?? BoxConstraints(maxWidth: size.width * .8),
          margin: margin,
          padding: padding,
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Message bubble
              GestureDetector(
                onTap: onTap,
                onDoubleTap: onDoubleTap,
                onLongPress: onLongPress,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(bubbleRadius),
                      topRight: Radius.circular(bubbleRadius),
                      bottomLeft: Radius.circular(tail
                          ? isSender
                              ? bubbleRadius
                              : 0
                          : BUBBLE_RADIUS),
                      bottomRight: Radius.circular(tail
                          ? isSender
                              ? 0
                              : bubbleRadius
                          : BUBBLE_RADIUS),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: SelectableText(
                      text,
                      style: textStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              // Time and status below the bubble
              if (stateTick)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (timeStateIcon != null) timeStateIcon,
                      if (timeStateIcon != null && stateIcon != null)
                        const SizedBox(width: 4),
                      if (stateIcon != null) stateIcon,
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (isSender && trailing != null) const SizedBox.shrink(),
      ],
    );
  }
}
