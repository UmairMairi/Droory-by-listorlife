import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_and_life/base/base.dart';

import '../animations/fade_animation.dart';

class AppTextField extends StatelessWidget {
  final String? title;
  final String? hint;
  final bool menditry;
  final int? lines;
  final Widget? titleWidget;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? inputType;
  final TextInputAction? action;
  final TextAlign? textAlign;
  final Widget? suffix;
  final bool? password;
  final double? vPadding;
  final EdgeInsetsGeometry? hPadding;
  final bool isExpanded;
  final Color? fillColor;
  final Color? borderSideColor;
  final double? sizedBoxWidth;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final bool? isMendotary;
  final double? width;
  final onSuffixTap;
  final bool? isDropDownShowing;
  final String? placeHolderText;
  final String? errorText;
  final Widget? prefix;
  final int? maxLength;
  final Function(bool)? onPrefixTap;
  final String? prefixText;
  final bool? editabled;
  final TextStyle? hintStyle;
  final bool readOnly;
  final EdgeInsetsGeometry? padding;
  final Color? titleColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enableCopyPaste;
  final VoidCallback? onTap;
  final bool animation;
  const AppTextField({
    super.key,
    this.title,
    this.animation = true,
    this.onTap,
    this.hint,
    this.vPadding,
    this.onChanged,
    this.lines,
    this.titleWidget,
    this.action,
    this.inputType,
    this.validator,
    this.password,
    this.suffix,
    this.inputFormatters,
    this.textAlign,
    this.sizedBoxWidth,
    this.fillColor,
    this.isExpanded = true,
    this.hPadding,
    this.borderSideColor,
    this.controller,
    this.focusNode,
    this.isMendotary,
    this.width,
    this.onSuffixTap,
    this.isDropDownShowing = false,
    this.placeHolderText,
    this.errorText,
    this.prefix,
    this.maxLength,
    this.onPrefixTap,
    this.prefixText,
    this.editabled,
    this.readOnly = false,
    this.menditry = false,
    this.padding,
    this.titleColor,
    this.hintStyle,
    this.enableCopyPaste = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(
          height: 05,
        ),
        FadeAnimation(
          delay: animation ? 0.3 : 0.0,
          child: Container(
            alignment: Alignment.center,
            width: width ?? MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: const Offset(0, 5), // Offset from the top
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 10.0), // Adjusted padding
            child: TextFormField(
              autovalidateMode: AutovalidateMode.disabled,
              controller: controller,
              keyboardType: inputType,
              readOnly: readOnly,
              onTap: onTap,
              cursorColor: titleColor ?? Colors.black,
              maxLines: password == true ? 1 : lines,
              obscureText: lines == null ? password == true : false,
              validator: validator ?? validator,
              maxLength: maxLength,
              textAlign: textAlign ?? TextAlign.start,
              focusNode: focusNode,
              enabled: editabled ?? true,
              textInputAction: action ?? TextInputAction.done,
              textAlignVertical:
                  TextAlignVertical.center, // Center text vertically
              onChanged: onChanged,
              inputFormatters: inputFormatters,
              enableInteractiveSelection: enableCopyPaste ?? false,
              style: context.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: (hint ?? '').isNotEmpty ? capitalize(hint ?? '') : "",
                counterText: "",
                hintStyle: hintStyle,
                errorText: errorText,
                filled: false,
                errorMaxLines: 2,
                prefixIcon: prefix,
                prefixIconColor: Theme.of(context).colorScheme.primary,
                border: InputBorder.none,
                suffixIconColor: Theme.of(context).colorScheme.primary,
                suffixIcon: suffix,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0), // Ensure vertical centering
              ),
            ),
          ),
        ),
      ],
    );
  }

  String capitalize(String value) {
    if (value.trim().isEmpty) return "";
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }
}
