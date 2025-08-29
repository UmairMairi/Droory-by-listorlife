import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/view_model/auth_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:pinput/pinput.dart';

import '../../base/helpers/string_helper.dart';
import '../../res/assets_res.dart';
import '../../widgets/app_resend_otp_button.dart';

class VerificationView extends BaseView<AuthVM> {
  VerificationView({super.key});
  final TextEditingController otpTextController = TextEditingController();

  @override
  Widget build(BuildContext context, AuthVM viewModel) {
    // Default theme for the OTP boxes: square boxes with slight rounding.
    var defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(left: 15, top: 10),
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // square with slight rounding
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 0.5,
            blurRadius: 0.5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    // Focused theme: only the currently active box will use this red-highlight style.
    var focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.verification),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(25),
            Image.asset(
              AssetsRes.OTP_SCREEN,
              height: 120,
            ),
            const Flexible(child: Gap(40)),
            // Display the instructions + phone number as a RichText,
            // forcing the phone number to remain LTR.
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: context.textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: '${StringHelper.enterThe4DigitCode} \n',
                  ),
                  WidgetSpan(
                    child: Directionality(
                      textDirection:
                          TextDirection.ltr, // Force LTR for the phone
                      child: Text(
                        '${viewModel.countryCode}-${viewModel.phoneTextController.text.trim()}',
                        style: context.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            Align(
              alignment: Alignment.center,
              child: Text(
                StringHelper.otp,
                style: context.textTheme.titleMedium,
              ),
            ),
            const Gap(10),
            // Pinput widget with numeric keyboard and smooth focus animation.
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                controller: otpTextController,
                keyboardType: TextInputType.number, // Numeric keyboard
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: defaultPinTheme,
                errorPinTheme: focusedPinTheme,
                obscureText: false,
                obscuringCharacter: "*",
                separatorBuilder: (index) => const SizedBox(width: 15),
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                animationDuration: const Duration(milliseconds: 200),
                animationCurve: Curves.easeInOut,
                pinAnimationType: PinAnimationType.scale,
                onCompleted: (pin) {
                  debugPrint('onCompleted: $pin');
                },
                onChanged: (value) {
                  debugPrint('onChanged: $value');
                },
              ),
            ),
            const Gap(30),
            AppElevatedButton(
              width: MediaQuery.of(context).size.width,
              onTap: () {
                if (otpTextController.text.trim().isEmpty) {
                  DialogHelper.showToast(message: FormFieldErrors.otpRequired);
                  return;
                }
                if (otpTextController.text.trim().length < 4) {
                  DialogHelper.showToast(message: FormFieldErrors.invalidOtp);
                  return;
                }
                DialogHelper.showLoading();
                viewModel.verifyOtpApi(otp: otpTextController.text.trim());
              },
              title: StringHelper.verifyButton,
            ),
            const Gap(30),

            // New: "Didn't receive code?" text above the resend button
            Column(
              children: [
                Text(
                  StringHelper.didntReceiveCode,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(8),
                AppResendOtpButton(
                  seconds: 30,
                  onResend: () {
                    viewModel.loginApi(resend: true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
