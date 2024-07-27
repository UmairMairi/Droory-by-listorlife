import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_outline_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../widgets/app_map_widget.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
        centerTitle: true,
      ),
      body: Consumer<HomeVM>(builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      viewModel.selectedIndex = 0;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: viewModel.selectedIndex == 0
                            ? Colors.black
                            : Colors.white,
                      ),
                      child: Text(
                        "New",
                        style: context.textTheme.titleMedium?.copyWith(
                          color: viewModel.selectedIndex == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.selectedIndex = 1;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        color: viewModel.selectedIndex == 0
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Text(
                        "Used",
                        style: context.textTheme.titleMedium?.copyWith(
                            color: viewModel.selectedIndex == 1
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Price",
                style: context.textTheme.titleSmall,
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: context.width,
                      height: 50,
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: viewModel.startPriceTextController,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              fillColor: const Color(0xffFCFCFD),
                              hintText: "EGP0",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xffEFEFEF)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xffEFEFEF)),
                              ))),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "to",
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: context.width,
                      height: 50,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        controller: viewModel.endPriceTextController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            fillColor: const Color(0xffFCFCFD),
                            hintText: "EGP0",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xffEFEFEF))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xffEFEFEF)))),
                      ),
                    ),
                  ),
                ],
              ),
              /* const SizedBox(
                  height: 15,
                ),
                StatefulBuilder(builder: (context, setState) {
                  SfRangeValues values = const SfRangeValues(00, 20000);
                  return SfRangeSlider(
                    min: 0,
                    max: 20000.0,
                    values: values,
                    inactiveColor: Colors.grey,
                    activeColor: const Color(0xffFF385C),
                    showLabels: true,
                    interval: 20000,
                    labelFormatterCallback:
                        (dynamic actualValue, String formattedText) {
                      return actualValue == 19999
                          ? ' $formattedText+'
                          : ' $formattedText';
                    },
                    onChanged: (SfRangeValues newValues) {},
                  );
                }),
                */
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              AppTextField(
                title: 'Location',
                hint: 'Select Location',
                controller: viewModel.locationTextController,
                readOnly: true,
                onTap: () async {
                  Map<String, dynamic>? value = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppMapWidget()));
                  print(value);
                  if (value != null && value.isNotEmpty) {
                    viewModel.locationTextController.text =
                        "${value['location']}, ${value['city']}, ${value['state']}";
                    viewModel.latitude = double.parse(value['latitude']);
                    viewModel.longitude = double.parse(value['longitude']);
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: const Color(0xffEAEEF1),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.zero,
                    initiallyExpanded: false,
                    title: Text(
                      viewModel.sortBy,
                      style: context.textTheme.titleSmall,
                    ),
                    backgroundColor: Colors.white,
                    children: [
                      ListTile(
                        title: Text(
                          "Price: High to Low",
                          selectionColor: Colors.white,
                        ),
                        onTap: () => viewModel.sortBy = "Price: High to Low",
                      ),
                      ListTile(
                        title: Text("Price: Low to High"),
                        onTap: () => viewModel.sortBy = "Price: Low to High",
                      ),
                      ListTile(
                        title: Text("Date Published"),
                        onTap: () => viewModel.sortBy = "Price: Low to High",
                      ),
                      ListTile(
                        title: Text("Distance"),
                        onTap: () => viewModel.sortBy = "Distance",
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: const Color(0xffEAEEF1),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.zero,
                    title: Text(
                      viewModel.publishedBy,
                      style: context.textTheme.titleSmall,
                    ),
                    backgroundColor: Colors.white,
                    children: [
                      ListTile(
                        title: Text(
                          "Today",
                          selectionColor: Colors.white,
                        ),
                        onTap: () => viewModel.publishedBy = "Today",
                      ),
                      ListTile(
                        title: Text("Yesterday"),
                        onTap: () => viewModel.publishedBy = "Yesterday",
                      ),
                      ListTile(
                        title: Text("Last Week"),
                        onTap: () => viewModel.publishedBy = "Last Week",
                      ),
                      ListTile(
                        title: Text("Last Month"),
                        onTap: () => viewModel.publishedBy = "Last Month",
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              AppElevatedButton(
                width: context.width,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                onTap: () {
                  context.pop();
                },
                title: 'Apply',
              ),
              const Gap(10),
              AppOutlineButton(
                title: 'Reset',
                width: context.width,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                onTap: () {},
              ),
            ],
          ),
        );
      }),
    );
  }
}
