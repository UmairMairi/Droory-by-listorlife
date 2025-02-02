import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const double BUBBLE_RADIUS_IMAGE = 16;

class BubbleNormalImage extends StatelessWidget {
  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  final String id;
  final Widget image;
  final String imageUrl;
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
    required this.imageUrl,
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
    Widget? timeStateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 15,
        color: Colors.grey,
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 15,
        color: Colors.grey,
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 15,
        color: Colors.green,
      );
    }

    if (timeStamp) {
      stateTick = true;
      timeStateIcon = Text(
        createdAt ?? '',
        style: const TextStyle(
          fontSize: 8,
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
                        imageUrl: imageUrl,
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
                    stateIcon != null || timeStateIcon !=null && stateTick
                        ? Positioned(
                      bottom: 4,
                      right: 6,
                      child: Row(
                        children: [
                          timeStateIcon??SizedBox.shrink(),
                          SizedBox(width: 5,),
                          if(stateIcon!=null)...[
                            stateIcon
                          ]
                        ],
                      ),
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
  final String imageUrl;

  const _DetailScreen({required this.tag, required this.imageUrl});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

/// created using the Hero Widget
class _DetailScreenState extends State<_DetailScreen> {
  @override
  initState() {
    log(widget.imageUrl, name: "Image Url => ");
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
        appBar: AppBar(),
        body: Center(
          child: Hero(
            tag: widget.tag,
            child: InteractiveViewer(
                minScale: 0.2,
                maxScale: 5.0,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
