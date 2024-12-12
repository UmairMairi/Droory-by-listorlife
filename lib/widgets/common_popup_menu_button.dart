import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class CommonPopupMenuButton<T> extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      constraints: constraints,
      clipBehavior: Clip.hardEdge,
      icon: icon,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
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

class CommonDropdown<T> extends StatelessWidget {
  final List<T> options;
  final Function(T?)? onChanged;
  final T displayLabel;
  final String? hintText;
  final Color? borderSideColor;
  final TextStyle? hintStyle;
  final String? Function(T?)? validator;
  final String? title;
  final Color? titleColor;

  const CommonDropdown(
      {super.key,
      required this.options,
      required this.onChanged,
      this.hintText,
      this.borderSideColor,
      required this.displayLabel,
      this.hintStyle,
      this.validator,
      this.title,
      this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              color:
                  titleColor ?? Theme.of(context).textTheme.titleSmall?.color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
        ],
        CustomDropdown<T>(
            hintText: hintText ?? "",
            items: options,
            excludeSelected: false,
            onChanged: onChanged,
            validator: validator ??
                (value) {
                  if (value == null) {
                    return "*This field is required";
                  }
                  return null;
                },
            decoration: CustomDropdownDecoration(
              closedBorder:
                  Border.all(color: borderSideColor ?? Colors.grey.shade300),
              closedBorderRadius: BorderRadius.circular(8.0),
              closedErrorBorder: Border.all(color: Colors.red),
              closedErrorBorderRadius: BorderRadius.circular(8.0),
              hintStyle: hintStyle ?? TextStyle(color: Colors.grey.shade500),
              expandedBorder:
                  Border.all(color: borderSideColor ?? Colors.grey.shade300),
              expandedBorderRadius: BorderRadius.circular(8.0),
            )),
      ],
    );
  }
}
