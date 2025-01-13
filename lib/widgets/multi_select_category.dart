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
  final bool inDialog;
  final String? choiceString;
  const MultiSelectCategory({
    super.key,
    required this.onSelectedCommunicationChoice,
    this.inDialog = false,
    this.choiceString,
  });

  @override
  State<MultiSelectCategory> createState() => _MultiSelectCategoryState();
}

class _MultiSelectCategoryState extends State<MultiSelectCategory> {
  final List<String> categories = ["Call", "WhatsApp", "Chat"];
  List<String> selectedCategories = ["Chat"]; // Ensure "Chat" is always selected

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if ((widget.choiceString ?? "").isNotEmpty) {
        updateSelectedCategories(widget.choiceString ?? "");
      } else {
        updateSelectedCategories(
          DbHelper.getUserModel()?.communicationChoice ?? '',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.inDialog
        ? Wrap(
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
              if (category != "Chat") {
                setState(() {
                  if (isSelected) {
                    selectedCategories.add(category);
                  } else {
                    selectedCategories.remove(category);
                  }
                });
                _updateCommunicationChoice();
              }
            },
          ),
        );
      }).toList(),
    )
        : Row(
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
              if (category != "Chat") {
                setState(() {
                  if (isSelected) {
                    selectedCategories.add(category);
                  } else {
                    selectedCategories.remove(category);
                  }
                });
                _updateCommunicationChoice();
              }
            },
          ),
        );
      }).toList(),
    );
  }

  void _updateCommunicationChoice() {
    CommunicationChoice choice;

    // Determine the CommunicationChoice based on the selected categories
    if (selectedCategories.length == 3) {
      choice = CommunicationChoice.call_chat_whatsapp; // All three selected
    } else if (selectedCategories.contains("Call") &&
        selectedCategories.contains("WhatsApp")) {
      choice = CommunicationChoice.call_whatsapp; // Call and WhatsApp selected
    } else if (selectedCategories.contains("Call")) {
      choice = CommunicationChoice.call; // Only Call selected
    } else if (selectedCategories.contains("WhatsApp")) {
      choice = CommunicationChoice.chat_whatsapp; // Chat and WhatsApp selected
    } else {
      choice = CommunicationChoice.chat; // Only Chat (default)
    }

    // Trigger the callback with the determined choice
    widget.onSelectedCommunicationChoice(choice);
  }

  // Function to update the selected categories based on a string
  void updateSelectedCategories(String choiceString) {
    setState(() {
      selectedCategories.clear();
      selectedCategories.add("Chat"); // Always add "Chat"

      // Update selectedCategories based on the string input
      switch (choiceString) {
        case 'call_chat_whatsapp':
          selectedCategories.addAll(["Call", "WhatsApp"]);
          break;
        case 'call_chat':
          selectedCategories.add("Call");
          break;
        case 'chat_whatsapp':
          selectedCategories.add("WhatsApp");
          break;
        case 'call_whatsapp':
          selectedCategories.addAll(["Call", "WhatsApp"]);
          break;
        case 'call':
          selectedCategories.add("Call");
          break;
        case 'whatsapp':
          selectedCategories.add("WhatsApp");
          break;
        case 'none':
        default:
          break; // Only "Chat" remains selected
      }
    });

    // Update the communication choice
    _updateCommunicationChoice();
  }
}
