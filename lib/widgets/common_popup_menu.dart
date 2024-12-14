import 'package:flutter/material.dart';

class CommonPopupMenuButton<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> Function(BuildContext)? itemBuilder;
  final Icon icon;
  final List<T> options;
  final Function(T) onSelected;
  final BoxConstraints constraints;
  final String Function(T) displayLabel; // Converts T to String for display

  const CommonPopupMenuButton({
    super.key,
    required this.icon,
    required this.options,
    required this.onSelected,
    required this.displayLabel,
    this.constraints = const BoxConstraints(
      maxWidth: double.infinity,
      minWidth: double.infinity,
    ),
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      constraints: constraints,
      clipBehavior: Clip.hardEdge,
      icon: icon,
      onSelected: onSelected,
      itemBuilder:itemBuilder ??(BuildContext context) {
        return options.map((option) {
          return PopupMenuItem<T>(
            value: option,
            child: Text(displayLabel(option)),
          );
        }).toList();
      },
    );
  }
}
