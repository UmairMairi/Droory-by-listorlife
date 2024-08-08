import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';

import '../../base/helpers/app_string.dart';
import '../../base/helpers/dialog_helper.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_elevated_button.dart';
import 'add_card_screen.dart';

class SelectCardView extends StatefulWidget {
  const SelectCardView({super.key});

  @override
  State<SelectCardView> createState() => _SelectCardViewState();
}

class _SelectCardViewState extends State<SelectCardView> {
  int _selectedCardIndex = -1; // -1 indicates no card is selected

  final List<Map<String, String>> _cards = [
    {'cardNumber': '**** **** **** 1234', 'expiryDate': '12/26'},
    {'cardNumber': '**** **** **** 5678', 'expiryDate': '01/25'},
  ];

  void _onCardSelected(int index) {
    setState(() {
      _selectedCardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.paymentOptions),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: context.theme.primaryColor,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          AppString.addCard,
          style: context.textTheme.titleSmall?.copyWith(color: Colors.white),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const AddCardScreen();
              });
        },
      ),
      bottomNavigationBar: AppElevatedButton(
        width: context.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        onTap: () {
          if (_selectedCardIndex < 0) {
            DialogHelper.showToast(message: AppString.pleaseSelectCard);
            return;
          }
          context.go(Routes.main);
          //context.go(Routes.main);
        },
        title: AppString.payNow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppString.selectCardAddNewCard,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Column(
              children: _cards.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> card = entry.value;
                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: Text(card[AppString.cardNumber]!),
                    subtitle: Text('${AppString.expiry} ${card[AppString.expiryDate]}'),
                    trailing: Radio<int>(
                      value: index,
                      groupValue: _selectedCardIndex,
                      onChanged: (int? value) {
                        _onCardSelected(value!);
                      },
                    ),
                    selected: _selectedCardIndex == index,
                    onTap: () => _onCardSelected(index),
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
