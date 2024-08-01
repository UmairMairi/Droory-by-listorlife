import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';

class MessageBarWithSuggestions extends StatefulWidget {
  final List<String> suggestions;
  final TextEditingController textController;
  final Function(String) onSuggestionSelected;
  final Function(double) onOfferMade;

  final Function(String) onSubmitted;
  final Function() onPickImageClick;
  final Function() onRecordingClick;

  const MessageBarWithSuggestions({
    super.key,
    required this.suggestions,
    required this.textController,
    required this.onSuggestionSelected,
    required this.onOfferMade,
    required this.onSubmitted,
    required this.onPickImageClick,
    required this.onRecordingClick,
  });

  @override
  State<MessageBarWithSuggestions> createState() =>
      _MessageBarWithSuggetionsState();
}

class _MessageBarWithSuggetionsState extends State<MessageBarWithSuggestions> {
  bool isMakingOffer = false;
  final TextEditingController _offerController = TextEditingController();
  final FocusNode _offerFocusNode = FocusNode();

  @override
  void dispose() {
    _offerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
                indicator: BoxDecoration(color: Colors.black54),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                physics: NeverScrollableScrollPhysics(),
                tabs: [
                  Tab(
                    text: 'Questions',
                    height: 40,
                  ),
                  Tab(
                    text: 'Make Offer',
                    height: 40,
                  ),
                ]),
            Flexible(
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildSuggestionsSection(),
                    _buildOfferSection(),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20),
          child: Wrap(
            spacing: 8.0,
            children: widget.suggestions
                .map((suggestion) => ActionChip(
                      label: Text(
                        suggestion,
                        style: context.textTheme.bodyMedium
                            ?.copyWith(color: Colors.black),
                      ),
                      onPressed: () {
                        widget.onSuggestionSelected(suggestion);
                      },
                    ))
                .toList(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: widget.textController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.send,
                          maxLines: 3,
                          minLines: 1,
                          onSubmitted: (String? value) {
                            if (widget.textController.text.trim().isEmpty) {
                              return;
                            }
                            widget.onSubmitted(widget.textController.text);
                            widget.textController.clear();
                          },
                          decoration: const InputDecoration(
                              hintText: 'Type here...',
                              border: InputBorder.none),
                        ),
                      ),
                      InkWell(
                        child: const Icon(Icons.attach_file),
                        onTap: () {
                          widget.onPickImageClick();
                        },
                      ),
                      /* const Gap(03),
                      InkWell(
                        child: const Icon(Icons.mic),
                        onTap: () {
                          widget.onRecordingClick();
                        },
                      ),*/
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: IconButton(
                  onPressed: () {
                    if (widget.textController.text.trim().isEmpty) {
                      return;
                    }
                    widget.onSubmitted(widget.textController.text);
                    widget.textController.clear();
                  },
                  icon: const Icon(
                    CupertinoIcons.location_fill,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOfferSection() {
    return KeyboardActions(
      config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
          keyboardBarColor: Colors.grey[200],
          actions: [
            KeyboardActionsItem(
              focusNode: _offerFocusNode,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'Offer Price',
              style: context.textTheme.titleMedium,
            ),
            Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'EGP',
                      style: context.textTheme.titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _offerController,
                          focusNode: _offerFocusNode,
                          inputFormatters:
                              AppTextInputFormatters.withDecimalFormatter(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter your offer',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50.0, left: 50),
              child: AppElevatedButton(
                height: 45,
                width: context.width,
                onTap: () {
                  if (_offerController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: "Please enter offer amount");
                    return;
                  }

                  widget.onOfferMade(double.parse(_offerController.text));
                  _offerController.clear();
                },
                title: 'Send',
              ),
            )
          ],
        ),
      ),
    );
  }
}
