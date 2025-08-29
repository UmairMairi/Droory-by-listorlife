import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';

class AppTextField extends StatelessWidget {
  final String? title;
  final String? hint;
  final bool? isMandatory;
  final int? maxLines;
  final int? minLines;
  final Widget? titleWidget;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final Widget? suffix;
  final bool? isPassword;
  final double? verticalPadding;
  final EdgeInsetsGeometry? horizontalPadding;
  final bool isExpanded;
  final Color? fillColor;
  final Color? borderSideColor;
  final double? iconSpacing;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final double? width;
  final bool? isDropDownShowing;
  final String? placeholderText;
  final String? errorText;
  final Widget? prefix;
  final bool removeTextFieldBorder;
  final int? maxLength;
  final Function(bool)? onPrefixTap;
  final String? prefixText;
  final bool? isEditable;
  final int? elevation;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final bool readOnly;
  final EdgeInsetsGeometry? padding;
  final Color? titleColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enableCopyPaste;
  final VoidCallback? onTap;
  final bool showAnimation;
  final bool? autofocus;
  final TextCapitalization? textCapitalization;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final TextDirection? textDirection;
  final bool? autocorrect;
  final ToolbarOptions? toolbarOptions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final GlobalKey<FormState>? formKey;
  final Color? cursorColor;

  const AppTextField({
    super.key,
    this.title,
    this.hint,
    this.contentPadding = const EdgeInsets.symmetric(
        horizontal: 10.0), // Default padding added here
    this.isMandatory =
        true, // Changed default to true for backward compatibility
    this.maxLines,
    this.minLines,
    this.titleWidget,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.textAlign = TextAlign.start,
    this.removeTextFieldBorder = false,
    this.suffix,
    this.isPassword = false,
    this.verticalPadding = 15.0,
    this.horizontalPadding,
    this.isExpanded = true,
    this.fillColor,
    this.borderSideColor,
    this.iconSpacing,
    this.focusNode,
    this.onChanged,
    this.width,
    this.isDropDownShowing = false,
    this.placeholderText,
    this.errorText,
    this.prefix,
    this.maxLength,
    this.onPrefixTap,
    this.prefixText,
    this.isEditable = true,
    this.elevation,
    this.hintStyle,
    this.readOnly = false,
    this.padding,
    this.titleColor,
    this.inputFormatters,
    this.enableCopyPaste = true,
    this.onTap,
    this.showAnimation = true,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.textDirection,
    this.autocorrect = true,
    this.toolbarOptions,
    this.maxLengthEnforcement,
    this.formKey,
    this.cursorColor,
  });

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
        TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            keyboardType: keyboardType,
            autofocus: autofocus!,
            textCapitalization: textCapitalization!,
            keyboardAppearance: keyboardAppearance,
            scrollPadding: scrollPadding,
            textAlignVertical: TextAlignVertical.center,
            textDirection: textDirection,
            autocorrect: autocorrect!,
            toolbarOptions: toolbarOptions,
            maxLengthEnforcement: maxLengthEnforcement,
            readOnly: readOnly,
            onTap: onTap,
            cursorColor: cursorColor ?? Colors.black,
            maxLines: isPassword == true ? 1 : maxLines,
            minLines: minLines,
            obscureText: isPassword == true,
            validator: validator ??
                (value) {
                  // FIXED: Only validate if field is mandatory
                  if (isMandatory == true) {
                    if (value == null || value.trim().isEmpty) {
                      return "*${StringHelper.fieldShouldNotBeEmpty}";
                    }
                  }
                  return null;
                },
            maxLength: maxLength,
            textAlign: textAlign,
            focusNode: focusNode,
            enabled: isEditable,
            textInputAction: textInputAction ?? TextInputAction.done,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            enableInteractiveSelection: enableCopyPaste!,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hint != null ? capitalize(hint!) : "",
              counterText: "",
              hintStyle: hintStyle ?? TextStyle(color: Colors.grey.shade500),
              errorText: errorText,
              filled: fillColor != null,
              fillColor: fillColor,
              errorMaxLines: 2,
              prefixIcon: prefix,
              prefixIconColor: Theme.of(context).colorScheme.primary,
              suffixIcon: suffix,
              suffixIconColor: Theme.of(context).colorScheme.primary,
              contentPadding: contentPadding,
              border: removeTextFieldBorder
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                          color: borderSideColor ?? Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
              enabledBorder: removeTextFieldBorder
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                          color: borderSideColor ?? Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
              focusedBorder: removeTextFieldBorder
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                          color: borderSideColor ?? Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
              errorBorder: removeTextFieldBorder
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
            )),
      ],
    );
  }

  String capitalize(String value) {
    return value.isNotEmpty
        ? "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}"
        : "";
  }
}
