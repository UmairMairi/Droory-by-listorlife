import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  SfRangeValues _values = const SfRangeValues(00, 20000);

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
                  onTap: () {},
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black,
                    ),
                    child: const Text(
                      "New",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    child: const Text(
                      "Used",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
            const Text(
              "Price",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
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
                                borderSide: const BorderSide(
                                    color: Color(0xffEFEFEF))))),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text("to"),
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
            const Text(
              "Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Container(
                width: context.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                color: const Color(0xffEAEEF1),
                child: const Text(
                  "New York City. USA",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: const Color(0xffEAEEF1),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: const ExpansionTile(
                  childrenPadding: EdgeInsets.zero,
                  initiallyExpanded: false,
                  title: Text("Sort By"),
                  backgroundColor: Colors.white,
                  children: [
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
                child: const ExpansionTile(
                  childrenPadding: EdgeInsets.zero,
                  title: Text("Posted Within"),
                  backgroundColor: Colors.white,
                  children: [
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
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Container(
                alignment: Alignment.center,
                width: context.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                width: context.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black, width: 2)),
                child: const Text(
                  "Reset",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
