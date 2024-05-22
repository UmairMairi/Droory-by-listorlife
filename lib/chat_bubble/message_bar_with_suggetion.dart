import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
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
                  ),
                  Tab(
                    text: 'Make Offer',
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
        Wrap(
          spacing: 8.0,
          children: widget.suggestions
              .map((suggestion) => ActionChip(
                    label: Text(suggestion),
                    onPressed: () {
                      widget.onSuggestionSelected(suggestion);
                    },
                  ))
              .toList(),
        ),
        const SizedBox(
          height: 20,
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: widget.textController,
                  onSubmitted: (value) {
                    print(value);
                    widget.onSubmitted(value);
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                      hintText: 'Type here...', border: InputBorder.none),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () {
                  widget.onPickImageClick();
                },
              ),
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () {
                  widget.onRecordingClick();
                },
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOfferSection() {
    return Padding(
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
            height: 10,
          ),
          AppElevatedButtonWithoutAnimation(
            width: context.width,
            onTap: () {
              if (_offerController.text.trim().isEmpty) {
                return;
              }
              widget.onOfferMade(double.parse(_offerController.text));
            },
            title: 'Send',
          )
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Type here...',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.attach_file),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.mic),
          onPressed: () {},
        ),
      ],
    );
  }
}
