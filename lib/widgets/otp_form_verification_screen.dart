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

class OtpFormVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  final VoidCallback onVerificationSuccess;

  const OtpFormVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
    required this.onVerificationSuccess,
  });

  @override
  State<OtpFormVerificationScreen> createState() =>
      _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OtpFormVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  late ProfileVM profileViewModel;
  bool _isVerifying = false; // Prevent multiple submissions

  @override
  void initState() {
    super.initState();
    profileViewModel = context.read<ProfileVM>();
  }

  @override
  Widget build(BuildContext context) {
    // Default theme for the OTP boxes
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
        borderRadius: BorderRadius.circular(8),
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

    // Focused theme
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
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '${widget.countryCode}-${widget.phoneNumber}',
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
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                controller: otpController,
                keyboardType: TextInputType.number,
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
                  // 📝 NO AUTO-SUBMIT: User must manually click verify button
                },
                onChanged: (value) {
                  debugPrint('onChanged: $value');
                  // Update UI state when user types
                  setState(() {
                    // This will rebuild the verify button state
                  });
                },
              ),
            ),
            const Gap(30),
            // 🔴 MANUAL VERIFICATION: Always show the verify button
            AppElevatedButton(
              width: context.width,
              onTap: _isVerifying
                  ? null
                  : _verifyOTP, // Disable if already verifying
              title: _isVerifying ? "Verifying..." : StringHelper.verifyButton,
            ),
            const Gap(30),
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
                    // Clear the current OTP when resending
                    otpController.clear();
                    profileViewModel.sendVerificationPhone(
                      countryCode: widget.countryCode,
                      phone: widget.phoneNumber,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyOTP() async {
    // Prevent multiple simultaneous verification attempts
    if (_isVerifying) return;

    if (otpController.text.trim().isEmpty) {
      DialogHelper.showToast(message: FormFieldErrors.otpRequired);
      return;
    }
    if (otpController.text.trim().length < 4) {
      DialogHelper.showToast(message: FormFieldErrors.invalidOtp);
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    DialogHelper.showLoading();

    try {
      await profileViewModel.verifyOtpApi(
        countryCode: widget.countryCode,
        phoneNo: widget.phoneNumber,
        otp: otpController.text.trim(),
      );

      DialogHelper.hideLoading();

      // ✅ SUCCESS: Call the success callback FIRST
      widget.onVerificationSuccess();

      // 🔧 FIX: Pop back to the form screen after calling success callback
      // This ensures we return to the form, not the subcategory list
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      DialogHelper.hideLoading();

      // ❌ FAILURE: Clear the OTP field and show error
      otpController.clear();
      DialogHelper.showToast(message: FormFieldErrors.invalidOtp);
      debugPrint("❌ OTP verification error: $e");

      // 🚫 DO NOT call onVerificationSuccess() on failure
      // 🚫 DO NOT navigate back to the form
      // Keep user on OTP screen to retry
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
