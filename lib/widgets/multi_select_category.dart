import 'package:flutter/material.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';

enum CommunicationChoice {
  chat,
  call,
  whatsapp,
  call_chat,
  chat_whatsapp,
  call_whatsapp,
  call_chat_whatsapp,
  none,
}

class MultiSelectCategory extends StatefulWidget {
  final ValueChanged<CommunicationChoice> onSelectedCommunicationChoice;
  const MultiSelectCategory({
    Key? key,
    required this.onSelectedCommunicationChoice,
  }) : super(key: key);

  @override
  State<MultiSelectCategory> createState() => _MultiSelectCategoryState();
}

class _MultiSelectCategoryState extends State<MultiSelectCategory> {
  final List<String> categories = ["Call", "WhatsApp", "Chat"];
  List<String> selectedCategories = [];

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      updateSelectedCategories(
          DbHelper.getUserModel()?.communicationChoice ?? '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FilterChip(
              label: Text(category),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              side: const BorderSide(color: Colors.blue),
              selected: selectedCategories.contains(category),
              selectedColor: Colors.blue.withOpacity(0.2),
              onSelected: (bool isSelected) {
                setState(() {
                  if (isSelected) {
                    selectedCategories.add(category);
                  } else {
                    selectedCategories.remove(category);
                  }
                });
                _updateCommunicationChoice();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _updateCommunicationChoice() {
    CommunicationChoice choice;

    // Determine the CommunicationChoice based on the selected categories
    if (selectedCategories.isEmpty) {
      choice = CommunicationChoice.none; // No selections
    } else if (selectedCategories.length == 3) {
      choice = CommunicationChoice.call_chat_whatsapp; // All three selected
    } else if (selectedCategories.contains("Call") &&
        selectedCategories.contains("Chat")) {
      choice = CommunicationChoice.call_chat; // Call and Chat selected
    } else if (selectedCategories.contains("Chat") &&
        selectedCategories.contains("WhatsApp")) {
      choice = CommunicationChoice.chat_whatsapp; // Chat and WhatsApp selected
    } else if (selectedCategories.contains("Call") &&
        selectedCategories.contains("WhatsApp")) {
      choice = CommunicationChoice.call_whatsapp; // Call and WhatsApp selected
    } else if (selectedCategories.contains("Call")) {
      choice = CommunicationChoice.call; // Only Call selected
    } else if (selectedCategories.contains("Chat")) {
      choice = CommunicationChoice.chat; // Only Chat selected
    } else if (selectedCategories.contains("WhatsApp")) {
      choice = CommunicationChoice.whatsapp; // Only WhatsApp selected
    } else {
      choice = CommunicationChoice.none; // Fallback
    }

    // Trigger the callback with the determined choice
    widget.onSelectedCommunicationChoice(choice);
  }

  // Function to update the selected categories based on a string
  void updateSelectedCategories(String choiceString) {
    setState(() {
      selectedCategories.clear(); // Clear current selections

      // Update selectedCategories based on the string input
      switch (choiceString) {
        case 'call_chat_whatsapp':
          selectedCategories.addAll(["Call", "WhatsApp", "Chat"]);
          break;
        case 'call_chat':
          selectedCategories.addAll(["Call", "Chat"]);
          break;
        case 'chat_whatsapp':
          selectedCategories.addAll(["Chat", "WhatsApp"]);
          break;
        case 'call_whatsapp':
          selectedCategories.addAll(["Call", "WhatsApp"]);
          break;
        case 'call':
          selectedCategories.add("Call");
          break;
        case 'chat':
          selectedCategories.add("Chat");
          break;
        case 'whatsapp':
          selectedCategories.add("WhatsApp");
          break;
        case 'none':
        default:
          selectedCategories.clear(); // No selections
          break;
      }
    });

    // Update the communication choice
    _updateCommunicationChoice();
  }
}
