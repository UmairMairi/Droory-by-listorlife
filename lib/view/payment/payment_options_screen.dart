import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view/payment/select_card_view.dart';

import '../../widgets/app_elevated_button.dart';
import 'add_card_screen.dart';

class PaymentOptionsScreen extends StatefulWidget {
  const PaymentOptionsScreen({super.key});

  @override
  _PaymentOptionsScreenState createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  int _selectedPaymentMethod = -1; // -1 indicates no payment method is selected

  final List<Map<String, String>> _paymentMethods = [
    {
      'name': 'Dubizzle Wallet',
      'description': 'Balance : EGP 0',
      'icon': AssetsRes.IC_WALLET_ICON
    },
    {
      'name': 'Card Payment',
      'description': 'Pay with Visa or Mastercard',
      'icon': AssetsRes.IC_CARDS_ICON
    },
    /* {'name': 'Fawry', 'description': 'Fawry', 'icon': 'assets/icons/fawry.png'},

    {
      'name': 'Vodafone Cash',
      'description': 'Pay using Vodafone Cash',
      'icon': 'assets/icons/vodafone.png'
    },
    {
      'name': 'Orange Cash',
      'description': 'Pay using Orange Cash',
      'icon': 'assets/icons/orange.png'
    },
    {
      'name': 'Etisalat Cash',
      'description': 'Pay using Etisalat Cash',
      'icon': 'assets/icons/etisalat.png'
    },*/
  ];

  void _onPaymentMethodSelected(int index) {
    setState(() {
      _selectedPaymentMethod = index;
    });
  }

  void _onAddCard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment selection'),
      ),
      bottomNavigationBar: AppElevatedButton(
        width: context.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        onTap: () {
          if (_selectedPaymentMethod < 0) {
            DialogHelper.showToast(message: "Please Select Payment Method");
            return;
          }
          if (_selectedPaymentMethod == 0) {
            context.go(Routes.main);
            return;
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const SelectCardView()));
          //context.go(Routes.main);
        },
        title: 'Pay Now',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Methods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[200],
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Single Featured ad for 7 days'),
                  Text(
                    'EGP 260',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: _paymentMethods.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> method = entry.value;
                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading:
                        Image.asset(method['icon']!, width: 40, height: 40),
                    title: Text(method['name']!),
                    subtitle: Text(method['description']!),
                    trailing: Radio<int>(
                      value: index,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (int? value) {
                        _onPaymentMethodSelected(value!);
                      },
                    ),
                    selected: _selectedPaymentMethod == index,
                    onTap: () => _onPaymentMethodSelected(index),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
