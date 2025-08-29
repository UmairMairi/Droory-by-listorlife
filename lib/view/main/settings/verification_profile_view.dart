import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/extensions/context_extension.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/text_formatters/form_field_errors.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/view_model/profile_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_resend_otp_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VerificationProfileView extends StatefulWidget {
  final String? valueToVerify;
  final String verificationType; // 'email' or 'phone'
  final String? countryCode; // Only for phone

  const VerificationProfileView({
    super.key,
    required this.valueToVerify,
    required this.verificationType,
    this.countryCode,
  });

  @override
  State<VerificationProfileView> createState() =>
      _VerificationProfileViewState();
}

class _VerificationProfileViewState extends State<VerificationProfileView> {
  final TextEditingController otpTextController = TextEditingController();
  late ProfileVM viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read<ProfileVM>();
  }

  @override
  Widget build(BuildContext context) {
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
            // Display the instructions + contact info as a RichText,
            // forcing the contact info to remain LTR.
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
                          TextDirection.ltr, // Force LTR for contact info
                      child: Text(
                        widget.verificationType == 'email'
                            ? widget.valueToVerify?.trim() ?? ''
                            : '${widget.countryCode ?? ""}-${widget.valueToVerify?.trim() ?? ""}',
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
              onTap: _verifyOtp,
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
                    if (widget.verificationType == 'email') {
                      if (widget.valueToVerify != null) {
                        viewModel.sendVerificationMail(
                            email: widget.valueToVerify!);
                      }
                    } else {
                      // 'phone'
                      viewModel.sendVerificationPhone(
                          countryCode: widget.countryCode,
                          phone: widget.valueToVerify);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    if (otpTextController.text.trim().isEmpty) {
      DialogHelper.showToast(message: FormFieldErrors.otpRequired);
      return;
    }
    // Assuming OTP length is standard, e.g., 4. Adjust if different.
    if (otpTextController.text.trim().length < 4) {
      DialogHelper.showToast(message: FormFieldErrors.invalidOtp);
      return;
    }
    DialogHelper.showLoading();

    try {
      if (widget.verificationType == 'email') {
        await viewModel.verifyOtpEmailApi(
          otp: otpTextController.text.trim(),
          emailToVerify: widget.valueToVerify,
        );
      } else {
        // 'phone'
        await viewModel.verifyOtpApi(
          countryCode: widget.countryCode,
          phoneNo: widget.valueToVerify,
          otp: otpTextController.text.trim(),
        );
      }
      // If VM methods are successful, they should hide the dialog and handle navigation.
    } catch (e) {
      DialogHelper
          .hideLoading(); // Ensure loading is hidden if VM method throws
      DialogHelper.showToast(message: FormFieldErrors.invalidOtp);
      debugPrint("Verification OTP error in View: $e");
    } finally {
      // Removed 'if (DialogHelper.isLoadingVisible)' check.
      // If DialogHelper.hideLoading() is safe to call multiple times or when no dialog is visible,
      // this ensures it's hidden. However, the primary responsibility for hiding the dialog
      // shown by DialogHelper.showLoading() in this function lies within this function's scope (e.g., in the catch).
      // The VM methods also manage their own dialogs if they show any.
      // To be safe, ensure it's hidden if an error occurred and wasn't caught by VM.
      // But if DialogHelper.showLoading was only called once here, the catch block is sufficient.
      // For now, relying on the catch block. If a loader gets stuck, we might need to add it here.
    }
  }
}
