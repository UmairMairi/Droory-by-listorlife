import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/extensions/context_extension.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/text_formatters/form_field_errors.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/view_model/profile_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_otp_widget.dart';
import 'package:list_and_life/widgets/app_resend_otp_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VerificationProfileView extends StatefulWidget {
  final String? phoneNo;
   const VerificationProfileView({super.key, required this.phoneNo});

  @override
  State<VerificationProfileView> createState() => _VerificationProfileViewState();
}

class _VerificationProfileViewState extends State<VerificationProfileView> {
  final TextEditingController otpTextController = TextEditingController();

  late ProfileVM viewModel;
  @override
  void initState() {
     viewModel = context.read<ProfileVM>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      margin: EdgeInsets.only(left: 15, top: 10),
      textStyle: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300, // Shadow color
            spreadRadius: .5, // Spread radius
            blurRadius: .5, // Blur radius
            offset: Offset(0, 2), // Offset in x and y
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
              AssetsRes.APP_LOGO,
              height: 90,
            ),
            const Flexible(child: Gap(80)),
            Visibility(
              visible: (widget.phoneNo??"").contains("@"),
              child: Text(
                '${StringHelper.enterThe4DigitCode} \n${widget.phoneNo?.trim()}',
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Visibility(
              visible: !(widget.phoneNo??"").contains("@"),
              child: Text(
                '${StringHelper.enterThe4DigitCode} \n${viewModel.countryCode}-${widget.phoneNo?.trim()}',
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(20),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                StringHelper.otp,
                style: context.textTheme.titleSmall,
              ),
            ),
            Gap(
              05,
            ),
            Pinput(
              controller: otpTextController,
              defaultPinTheme: defaultPinTheme,
              obscureText: false,
              obscuringCharacter: "*",
              separatorBuilder: (index) => const SizedBox(width: 15),
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              focusedPinTheme: defaultPinTheme,
              submittedPinTheme: defaultPinTheme,
              errorPinTheme: defaultPinTheme,
            ),
            const Gap(30),
            // AppOtpWidget(
            //   size: 4,
            //   title: StringHelper.otp,
            //   onOtpEntered: (otp) {
            //     // Handle OTP entered
            //     viewModel.otpTextController.text = otp;
            //     debugPrint("Entered OTP: $otp");
            //   },
            // ),
            AppElevatedButton(
              width: context.width,
              onTap: () {
                if (otpTextController.text.trim().isEmpty) {
                  return;
                }
                if (otpTextController.text.trim().length < 4) {
                  DialogHelper.showToast(message: FormFieldErrors.invalidOtp);
                  return;
                }
                DialogHelper.showLoading();
                if((widget.phoneNo??"").contains("@")){
                  viewModel.verifyOtpEmailApi(
                      otp: otpTextController.text.trim());
                }else{
                  viewModel.verifyOtpApi(
                      countryCode: viewModel.countryCode,
                      phoneNo: widget.phoneNo, otp: otpTextController.text.trim());
                }

                /*context.go(Routes.completeProfile);*/
              },
              title: StringHelper.verifyButton,
            ),
            const Gap(30),
            AppResendOtpButton(
              seconds: 30,
              onResend: () {
                viewModel.sendVerificationPhone(countryCode: viewModel.countryCode,phone: widget.phoneNo);

                //debugPrint('Your new OTp is 1111');
              },
            )
          ],
        ),
      ),
    );
  }
}
