import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_outline_button.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../widgets/app_map_widget.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  SfRangeValues _values = const SfRangeValues(00, 20000);

  int selectedIndex = 0;
  String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: selectedIndex == 0 ? Colors.black : Colors.white,
                    ),
                    child: Text(
                      "New",
                      style: context.textTheme.titleMedium?.copyWith(
                        color: selectedIndex == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                      color: selectedIndex == 0 ? Colors.white : Colors.black,
                    ),
                    child: Text(
                      "Used",
                      style: context.textTheme.titleMedium?.copyWith(
                          color:
                              selectedIndex == 1 ? Colors.white : Colors.black),
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
                              borderSide:
                                  const BorderSide(color: Color(0xffEFEFEF)))),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SfRangeSlider(
              min: 0,
              max: 20000.0,
              values: _values,
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
              onChanged: (SfRangeValues newValues) {
                setState(() {
                  _values = newValues;
                });
                const SizedBox(
                  height: 5,
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Location",
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                Map<String, dynamic>? value = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AppMapWidget()));
                print(value);
                if (value != null && value.isNotEmpty) {
                  address =
                      "${value['location']}, ${value['city']}, ${value['state']}";
                  setState(() {});
                }
              },
              child: Container(
                  width: context.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  color: const Color(0xffEAEEF1),
                  child: Text(
                    address ?? "New York City. USA",
                    style: context.textTheme.titleSmall,
                  )),
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
                    "Sort By",
                    style: context.textTheme.titleSmall,
                  ),
                  backgroundColor: Colors.white,
                  children: const [
                    ListTile(
                      title: Text(
                        "High to Low",
                        selectionColor: Colors.white,
                      ),
                    ),
                    ListTile(
                      title: Text("Low to High"),
                    ),
                    ListTile(
                      title: Text("Date Published"),
                    ),
                    ListTile(
                      title: Text("Distance"),
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
                    "Posted Within",
                    style: context.textTheme.titleSmall,
                  ),
                  backgroundColor: Colors.white,
                  children: const [
                    ListTile(
                      title: Text(
                        "Today",
                        selectionColor: Colors.white,
                      ),
                    ),
                    ListTile(
                      title: Text("Yesterday"),
                    ),
                    ListTile(
                      title: Text("Last Week"),
                    ),
                    ListTile(
                      title: Text("Last Month"),
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
      ),
    );
  }
}
