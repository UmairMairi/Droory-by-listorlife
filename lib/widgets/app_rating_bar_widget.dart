import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AppRatingBarWidget extends StatelessWidget {
  final double initialRating;
  final double minRating;
  final double maxRating;
  final int itemCount;
  final double itemSize;
  final ValueChanged<double>? onRatingUpdate;
  final Axis direction;
  final bool isInteractive;
  final bool showText;
  final Gradient? gradient;
  final IconData icon;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final double iconSpacing;

  const AppRatingBarWidget({
    super.key,
    this.initialRating = 0.0,
    this.minRating = 1.0,
    this.maxRating = 5.0,
    this.itemCount = 5,
    this.itemSize = 40.0,
    this.onRatingUpdate,
    this.direction = Axis.horizontal,
    this.isInteractive = true,
    this.showText = false,
    this.gradient,
    this.icon = Icons.star,
    this.textStyle,
    this.padding,
    this.iconSpacing = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget ratingBar = RatingBar.builder(
      initialRating: initialRating,
      minRating: minRating,
      maxRating: maxRating,
      itemCount: itemCount,
      itemSize: itemSize,
      direction: direction,
      itemPadding: EdgeInsets.symmetric(horizontal: iconSpacing / 2),
      itemBuilder: (context, _) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return (gradient ?? const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 213, 114, 69),
                Color.fromARGB(255, 243, 223, 88),
                Color.fromARGB(255, 213, 114, 69),
              ],
            )).createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            );
          },
          child: Icon(
            icon,
            size: itemSize,
          ),
        );
      },
      onRatingUpdate: isInteractive ? onRatingUpdate ?? (rating) => debugPrint("$rating") : (value) {},
    );

    if (!isInteractive) {
      ratingBar = RatingBarIndicator(
        rating: initialRating,
        itemCount: itemCount,
        itemSize: itemSize,
        direction: direction,
        itemPadding: EdgeInsets.symmetric(horizontal: iconSpacing / 2),
        itemBuilder: (context, _) {
          return ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return (gradient ?? const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromARGB(255, 213, 114, 69),
                  Color.fromARGB(255, 243, 223, 88),
                  Color.fromARGB(255, 213, 114, 69),
                ],
              )).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              );
            },
            child: Icon(
              icon,
              size: itemSize,
            ),
          );
        },
      );
    }
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ratingBar,
          if (showText) ...[
            const SizedBox(width: 8),
            Text(
              initialRating.toStringAsFixed(1),
              style: textStyle ?? TextStyle(fontSize: itemSize / 2),
            ),
          ],
        ],
      ),
    );
  }
}
