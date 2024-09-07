import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/font_res.dart';

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
    return SizedBox(
      height: 120,
      child: KeyboardActions(
        config: KeyboardActionsConfig(
            keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
            keyboardBarColor: Colors.grey[200],
            actions: List.generate(
                widget.size,
                (index) => KeyboardActionsItem(
                      focusNode: _focusNodes[index],
                    ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? '',
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(
              height: 05,
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
                        color: Colors.grey.withOpacity(0.3), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 3, // Blur radius
                        offset: const Offset(0, 3), // Offset from the top
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,

                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: FontRes.MONTSERRAT_SEMIBOLD),
                    maxLength: 1,
                    autofocus: true, // Autofocus on the first field
                    focusNode: _focusNodes[index],
                    onChanged: (value) {
                      if (value.length == 1 && index < widget.size - 1) {
                        FocusScope.of(context).nextFocus();
                      } else {
                        if (index == 0) {
                          return;
                        }

                        FocusScope.of(context).previousFocus();
                      }
                      String otp = _controllers.fold<String>(
                          '',
                          (prev, controller) =>
                              prev +
                              (controller.text.isNotEmpty
                                  ? controller.text
                                  : ''));
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
        ),
      ),
    );
  }
}
