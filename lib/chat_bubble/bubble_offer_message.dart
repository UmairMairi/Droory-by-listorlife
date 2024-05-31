import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';

import 'bubble_normal_message.dart';

class BubbleOfferMessage extends StatelessWidget {
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
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final String? createdAt;
  const BubbleOfferMessage({
    super.key,
    required this.text,
    this.createdAt,
    this.constraints,
    this.onAccept,
    this.onReject,
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
          color: Colors.white70,
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
          constraints: constraints ??
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
          margin: margin,
          padding: padding,
          child: GestureDetector(
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
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: stateTick
                        ? const EdgeInsets.fromLTRB(16, 6, 50, 16)
                        : const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OFFER',
                          style: context.textTheme?.titleSmall
                              ?.copyWith(color: Colors.white),
                        ),
                        Gap(05),
                        SelectableText(
                          "EGP $text",
                          style: context.textTheme?.titleLarge
                              ?.copyWith(color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        !isSender
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      child: InkWell(
                                        onTap: () {},
                                        child: const Text(
                                          'Accept',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      child: InkWell(
                                        onTap: () {},
                                        child: const Text(
                                          'Reject',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                ],
                              )
                            : SizedBox.shrink()
                      ],
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
            ),
          ),
        ),
        if (isSender && trailing != null) const SizedBox.shrink(),
      ],
    );
  }
}
