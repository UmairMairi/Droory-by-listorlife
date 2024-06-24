import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SellFormSkeleton extends StatelessWidget {
  final bool isLoading;
  const SellFormSkeleton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload Images",
              style: context.textTheme.titleMedium,
            ),
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 138,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0, 1),
                        blurRadius: 6,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Upload",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Wrap(
              children: List.generate(2, (index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  width: 90,
                  height: 80,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0, 1),
                        blurRadius: 6,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Position Type",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                readOnly: true,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: "Select",
                  hintStyle:
                      TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Salary Period",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                readOnly: true,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: "Select",
                  hintStyle:
                      TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Salary from",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: "Enter",
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Salary to",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: "Enter",
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Ad Title",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: "Enter",
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Describe what you are selling",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: "Enter",
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Location",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: "Enter",
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Price (in EGP)",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: "Enter",
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100)),
              child: const Text(
                "Post Now",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
