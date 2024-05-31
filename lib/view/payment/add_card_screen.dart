import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              title: 'Name on card',
              hint: 'Enter',
              inputType: TextInputType.name,
              inputFormatters: AppTextInputFormatters.withNameFormatter(),
            ),
            const SizedBox(
              height: 10,
            ),
            AppTextField(
              title: 'Card Number',
              hint: 'Enter',
              inputType: TextInputType.number,
              inputFormatters: AppTextInputFormatters.withCardFormatter(),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    title: 'Exp. Date',
                    hint: 'Enter',
                    inputType: TextInputType.number,
                    inputFormatters:
                        AppTextInputFormatters.withExpiryDateFormatter(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: AppTextField(
                    title: 'CVV',
                    inputType: TextInputType.name,
                    inputFormatters: AppTextInputFormatters.withCVVFormatter(),
                    hint: 'Enter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppElevatedButton(
              onTap: () {
                // Save the card details and navigate back
                Navigator.pop(context);
              },
              height: 40,
              title: 'Save Card',
            )
          ],
        ),
      ),
    );
  }
}
