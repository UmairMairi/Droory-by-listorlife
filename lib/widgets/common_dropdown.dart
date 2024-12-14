import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import '../base/helpers/string_helper.dart';

class CommonDropdown<T> extends StatelessWidget {
  final List<T> options;
  final Function(T?)? onSelected;
  final Widget Function(BuildContext, T, bool, void Function())?
      listItemBuilder;
  final Widget Function(BuildContext, T, bool)? headerBuilder;
  final String? hint;
  final Color? borderSideColor;
  final TextStyle? hintStyle;
  final String? Function(T?)? validator;
  final String? title;
  final Color? titleColor;
  final T? initialItem;

  const CommonDropdown(
      {super.key,
      required this.options,
      required this.onSelected,
      this.hint,
      this.borderSideColor,
      this.hintStyle,
      this.validator,
      this.title,
      this.titleColor,
      this.listItemBuilder,
      this.initialItem,
      this.headerBuilder});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title ?? "",
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
            hintText: (hint ?? "").isNotEmpty ? hint : StringHelper.select,
            items: options,
            initialItem: initialItem,
            headerBuilder: headerBuilder,
            excludeSelected: false,
            onChanged: onSelected,
            listItemBuilder: listItemBuilder,
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
              hintStyle: hintStyle ?? TextStyle(color:(hint ?? "").isNotEmpty?Colors.black: Colors.grey.shade500),
              expandedBorder:
                  Border.all(color: borderSideColor ?? Colors.grey.shade300),
              expandedBorderRadius: BorderRadius.circular(8.0),
            )),
        const SizedBox(height: 6),
      ],
    );
  }
}
