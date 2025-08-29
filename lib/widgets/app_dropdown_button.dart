import 'package:flutter/material.dart';

class AppDropdownButton<T> extends StatelessWidget {
  final String? title;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final Function(T?)? onChanged;
  final bool isMandatory;
  final String? errorText;
  final bool readOnly;
  final EdgeInsetsGeometry? padding;
  final Color? titleColor;
  final bool enableCopyPaste;
  final VoidCallback? onTap;

  const AppDropdownButton({
    super.key,
    this.title,
    required this.items,
    this.value,
    this.onChanged,
    this.isMandatory = false,
    this.errorText,
    this.readOnly = false,
    this.padding,
    this.titleColor,
    this.enableCopyPaste = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: padding != null
                    ? const EdgeInsets.symmetric(horizontal: 20)
                    : EdgeInsets.zero,
                child: Text(
                  title ?? "",
                  style: TextStyle(
                    color: titleColor ?? Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              isMandatory
                  ? const Text(
                      '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(),
            ],
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<T>(
            items: items,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Select',
              errorText: errorText,
              filled: false,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onTap: onTap,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: Colors.black,
            ),
            icon: const Icon(Icons.arrow_drop_down),
            isExpanded: true,
            elevation: 8,
            iconSize: 24.0,
            isDense: true,
            dropdownColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
