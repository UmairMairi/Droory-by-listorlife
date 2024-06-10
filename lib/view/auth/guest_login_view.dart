import 'package:ccp_dialog/country_picker/flutter_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/db_helper.dart';
import 'package:list_and_life/res/font_res.dart';

import '../../base/base_view.dart';
import '../../base/text_formatters/text_formatters.dart';
import '../../view_model/auth_vm.dart';
import '../../widgets/app_text_field.dart';

class GuestLoginView extends BaseView<AuthVM> {
  const GuestLoginView({super.key});

  @override
  Widget build(BuildContext context, AuthVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            DbHelper.saveIsGuest(true);
            context.pop();
          },
          icon: Icon(
            Icons.close,
            weight: 20,
          ),
        ),
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log In now',
              style: context.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Please log in to continue",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 10,
            ),
            AppTextField(
              title: "Phone Number",
              hint: 'Phone Number',
              inputFormatters:
                  AppTextInputFormatters.withPhoneNumberFormatter(),
              controller: viewModel.phoneTextController,
              inputType: TextInputType.phone,
              prefix: CountryPicker(
                  selectedCountry: viewModel.selectedCountry,
                  dense: false,
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
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () {
                DbHelper.saveIsGuest(false);
                context.pop();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    color: const Color(0xff7F7F7F),
                    borderRadius: BorderRadius.circular(100)),
                child: const Text(
                  "Click to verify Phone number",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(children: <Widget>[
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
              Text(
                "Or Connect With",
                style: context.titleSmall,
              ),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
            ]),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
                onTap: () {
                  DbHelper.saveIsGuest(false);
                  context.pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: const Offset(0, 1),
                          blurRadius: 6,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlB3CZ5R6UsCPYh-Wa0R1N-6pV5_GQQiNaTDAgtC5j1A&s",
                        height: 25,
                      ),
                      const Text(
                        "Log In With Google",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: FontRes.MONTSERRAT_BOLD,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
                onTap: () {
                  DbHelper.saveIsGuest(false);

                  context.pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: const Offset(0, 1),
                          blurRadius: 6,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZngsd1bv9bgL4S44Ub44cpvL33LOTf0rYgkFTKTZFzw&s",
                        height: 25,
                      ),
                      const Text(
                        "Log In With IOS",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: FontRes.MONTSERRAT_BOLD,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
