import 'package:flutter/material.dart';
import 'package:list_and_life/view/main/sell/car/post_added_final_view.dart';

import 'include_car_detail_view.dart';

class ChooseLocationView extends StatelessWidget {
  const ChooseLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Location"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.09),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                        "Sharing accurate location helps you make a quicker sale",
                        style: TextStyle(fontSize: 13)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, right: 8, left: 10),
                    child: Icon(
                      Icons.location_on,
                      size: 30,
                      color: Color(0xffFF5093),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "What is the location of the car you \n are selling",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 35,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 6,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(100)),
              child: const Text(
                "Current location: New York City",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 6,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(100)),
              child: const Text(
                "Somewhere else",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const IncludeCarDetailView()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100)),
                child: const Text(
                  "Continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
