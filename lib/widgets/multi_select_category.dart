import 'package:flutter/material.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart'; // ADD THIS IMPORT

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
  // CHANGE: Use StringHelper for translated categories
  List<String> get categories =>
      [StringHelper.call, StringHelper.whatsapp, StringHelper.chat];
  List<String> selectedCategories = []; // Will be initialized in initState

  @override
  void initState() {
    super.initState();
    // Initialize with translated "Chat" string
    selectedCategories = [
      StringHelper.chat
    ]; // Ensure "Chat" is always selected

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
                    // CHANGE: Use StringHelper.chat instead of hardcoded "Chat"
                    if (category != StringHelper.chat) {
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
                    // CHANGE: Use StringHelper.chat instead of hardcoded "Chat"
                    if (category != StringHelper.chat) {
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

    // CHANGE: Use StringHelper for comparisons
    // Determine the CommunicationChoice based on the selected categories
    if (selectedCategories.length == 3) {
      choice = CommunicationChoice.call_chat_whatsapp; // All three selected
    } else if (selectedCategories.contains(StringHelper.call) &&
        selectedCategories.contains(StringHelper.whatsapp)) {
      choice =
          CommunicationChoice.call_chat_whatsapp; // Call and WhatsApp selected
    } else if (selectedCategories.contains(StringHelper.call)) {
      choice = CommunicationChoice.call_chat; // Only Call selected
    } else if (selectedCategories.contains(StringHelper.whatsapp)) {
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
      selectedCategories
          .add(StringHelper.chat); // Always add "Chat" (translated)

      // Update selectedCategories based on the string input
      switch (choiceString) {
        case 'call_chat_whatsapp':
          selectedCategories.addAll([StringHelper.call, StringHelper.whatsapp]);
          break;
        case 'call_chat':
          selectedCategories.add(StringHelper.call);
          break;
        case 'chat_whatsapp':
          selectedCategories.add(StringHelper.whatsapp);
          break;
        case 'call_whatsapp':
          selectedCategories.addAll([StringHelper.call, StringHelper.whatsapp]);
          break;
        case 'call':
          selectedCategories.add(StringHelper.call);
          break;
        case 'whatsapp':
          selectedCategories.add(StringHelper.whatsapp);
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
