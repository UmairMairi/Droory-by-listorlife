import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/auth_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';

import '../../res/assets_res.dart';
import '../../widgets/app_otp_widget.dart';
import '../../widgets/app_resend_otp_button.dart';

class VerificationView extends BaseView<AuthVM> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context, AuthVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
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
            const Flexible(child: Gap(100)),
            Text(
              'Enter the 4-digit code sent to you at +1 123 456 7890',
              style: context.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            AppOtpWidget(
              size: 4,
              title: "OTP",
              onOtpEntered: (otp) {
                // Handle OTP entered
                viewModel.otpTextController.text = otp;
                print("Entered OTP: $otp");
              },
            ),
            const Gap(30),
            AppElevatedButton(
              width: context.width,
              onTap: () {
                context.go(Routes.completeProfile);
              },
              title: 'Verify',
            ),
            const Gap(30),
            AppResendOtpButton(
              seconds: 30,
              onResend: () {
                print('Your new OTp is 1111');
              },
            )
          ],
        ),
      ),
    );
  }
}
