import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';

class AppOtpWidget extends StatefulWidget {
  final int size;
  final String? title;
  final Function(String) onOtpEntered;

  const AppOtpWidget(
      {super.key, required this.size, required this.onOtpEntered, this.title});

  @override
  State<AppOtpWidget> createState() => _AppOtpWidgetState();
}

class _AppOtpWidgetState extends State<AppOtpWidget> {
  List<FocusNode> _focusNodes = [];
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.size, (index) => FocusNode());
    _controllers =
        List.generate(widget.size, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title ?? '',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(
          height: 02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            widget.size,
            (index) => Container(
              width: 60, // Customize the size as needed
              height: 60,
              padding: const EdgeInsets.all(08),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(0, 5), // Offset from the top
                  ),
                ],
              ),
              child: TextField(
                controller: _controllers[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                autofocus: index == 0, // Autofocus on the first field
                focusNode: _focusNodes[index],
                onChanged: (value) {
                  if (value.length == 1 && index < widget.size - 1) {
                    _focusNodes[index].unfocus();
                    FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                  }
                  String otp = _controllers.fold<String>(
                      '',
                      (prev, controller) =>
                          prev +
                          (controller.text.isNotEmpty ? controller.text : ''));
                  if (otp.length == widget.size) {
                    widget.onOtpEntered(otp);
                    FocusScope.of(context).unfocus();
                  }
                },
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: '-',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
