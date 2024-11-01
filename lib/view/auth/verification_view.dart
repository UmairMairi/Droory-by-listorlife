import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/view_model/auth_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';

import '../../base/helpers/string_helper.dart';
import '../../res/assets_res.dart';
import '../../widgets/app_otp_widget.dart';
import '../../widgets/app_resend_otp_button.dart';

class VerificationView extends BaseView<AuthVM> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context, AuthVM viewModel) {
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
              AssetsRes.APP_LOGO,
              height: 90,
            ),
            const Flexible(child: Gap(80)),
            Text(
              '${StringHelper.enterThe4DigitCode} \n${viewModel.countryCode}-${viewModel.phoneTextController.text.trim()}',
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            AppOtpWidget(
              size: 4,
              title: StringHelper.otp,
              onOtpEntered: (otp) {
                // Handle OTP entered
                viewModel.otpTextController.text = otp;
                print("Entered OTP: $otp");
              },
            ),
            AppElevatedButton(
              width: context.width,
              onTap: () {
                if (viewModel.otpTextController.text.trim().isEmpty) {
                  DialogHelper.showToast(message: FormFieldErrors.otpRequired);
                  return;
                }
                if (viewModel.otpTextController.text.trim().length < 4) {
                  DialogHelper.showToast(message: FormFieldErrors.invalidOtp);
                  return;
                }
                DialogHelper.showLoading();
                viewModel.verifyOtpApi();

                /*context.go(Routes.completeProfile);*/
              },
              title: StringHelper.verifyButton,
            ),
            const Gap(30),
            AppResendOtpButton(
              seconds: 30,
              onResend: () {
                viewModel.loginApi(resend: true);
                //viewModel.resendOTP();
              },
            )
          ],
        ),
      ),
    );
  }
}
