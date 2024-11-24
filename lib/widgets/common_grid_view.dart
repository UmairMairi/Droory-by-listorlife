import 'package:flutter/material.dart';

class CommonGridView extends StatelessWidget {
  final int itemCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int crossAxisCount;
  final double childAspectRatio;
  final double? mainAxisExtent;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final bool shrinkWrap;

  const CommonGridView({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    required this.itemBuilder,
    this.mainAxisExtent,
    this.padding,
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      padding: padding??EdgeInsets.zero,
      physics: physics,
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
          mainAxisExtent: mainAxisExtent
      ),
      itemBuilder: itemBuilder,
    );
  }
}
