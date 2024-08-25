import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:searchfield/searchfield.dart';

import '../base/helpers/string_helper.dart';

class AppAutoCompleteTextField<T> extends StatelessWidget {
  final String? title;
  final String? hint;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final FormFieldValidator<T>? validator;
  final bool isMandatory;
  final String? errorText;
  final bool readOnly;
  final EdgeInsetsGeometry? padding;
  final Color? titleColor;
  final Function(SearchFieldListItem<T>)? onSuggestionSelected;
  final String Function(T) suggestionToString;
  final List<SearchFieldListItem<T>> suggestions;
  final Function(String)? onChanged;

  const AppAutoCompleteTextField({
    super.key,
    this.title,
    this.hint,
    this.onChanged,
    this.focusNode,
    required this.suggestions,
    this.controller,
    this.validator,
    this.isMandatory = false,
    this.errorText,
    this.readOnly = false,
    this.padding,
    this.titleColor,
    this.onSuggestionSelected,
    required this.suggestionToString,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey<AutoCompleteTextFieldState<T>> key = GlobalKey();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SearchField<T>(
        controller: controller,
        suggestions: suggestions,
        focusNode: focusNode,
        onSearchTextChanged: (search) => onChanged!(search),
        onSuggestionTap: onSuggestionSelected,
        searchStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13,
          color: Colors.black,
        ),
        searchInputDecoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xffd5d5d5))),
            hintStyle: context.textTheme.labelSmall,
            hintText: StringHelper.findCarsMobilePhonesAndMore),
        key: key,
      ),
    );
  }
}
