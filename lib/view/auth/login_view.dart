import 'package:ccp_dialog/country_picker/flutter_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';

import '../../base/helpers/dialog_helper.dart';
import '../../base/helpers/string_helper.dart';
import '../../view_model/auth_vm.dart';

class LoginView extends BaseView<AuthVM> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, AuthVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.login),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                DbHelper.saveIsGuest(true);
                context.go(Routes.main);
              },
              child: Text(
                StringHelper.guestLogin,
                style: context.textTheme.titleSmall?.copyWith(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red),
              ))
        ],
      ),
      body: SizedBox(
        height: context.height,
        child: KeyboardActions(
          config: KeyboardActionsConfig(
              keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
              keyboardBarColor: Colors.grey[200],
              actions: [
                KeyboardActionsItem(
                  focusNode: viewModel.nodeText,
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(25),
                Image.asset(
                  AssetsRes.APP_LOGO,
                  height: 90,
                ),
                const Flexible(child: Gap(100)),
                AppTextField(
                  title: StringHelper.phoneNumber,
                  hint: StringHelper.phoneNumber,
                  inputFormatters:
                      AppTextInputFormatters.withPhoneNumberFormatter(),
                  controller: viewModel.phoneTextController,
                  keyboardType: TextInputType.phone,
                  prefix: CountryPicker(
                      selectedCountry: viewModel.selectedCountry,
                      dense: true,
                      isEnable: false,
                      //displays arrow, true by default
                      showLine: false,
                      showFlag: true,
                      showFlagCircle: false,
                      showDialingCode: true,
                      //displays dialing code, false by default
                      showName: false,
                      //displays Name, true by default
                      withBottomSheet: true,
                      //displays country name, true by default
                      showCurrency: false,
                      //eg. 'British pound'
                      showCurrencyISO: false,
                      onChanged: (country) => viewModel.updateCountry(country)),
                ),
                const Flexible(child: Gap(50)),
                AppElevatedButton(
                  width: context.width,
                  onTap: () {
                    if (viewModel.phoneTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: FormFieldErrors.phoneNumberRequired);
                      return;
                    }
                    DialogHelper.showLoading();
                    viewModel.loginApi();
                  },
                  title: StringHelper.continueButton,
                ),
                const Flexible(child: Gap(100)),
                Text(
                  StringHelper.loginWithSocial,
                  style: context.textTheme.titleSmall,
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => viewModel.socialLogin(type: 1),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            AssetsRes.IC_GOOGLE_ICON,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    InkWell(
                      onTap: () => viewModel.socialLogin(type: 3),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            AssetsRes.IC_APPLE_ICON,
                            height: 30,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
