import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:list_and_life/view/main/sell/car/post_added_final_view.dart';

class IncludeCarDetailView extends StatefulWidget {
  const IncludeCarDetailView({super.key});

  @override
  State<IncludeCarDetailView> createState() => _IncludeCarDetailViewState();
}

class _IncludeCarDetailViewState extends State<IncludeCarDetailView> {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  var regexToRemoveEmoji =
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';
  int currentIndex = 1;
  int transmission = 0;

  File? image;
  Future pickImage(ImageSource source) async {
    final imagepicker = await ImagePicker().pickImage(source: source);
    if (imagepicker == null) return;
    final tempImage = File(imagepicker.path);
    setState(() {
      this.image = tempImage;
    });
  }

  TextEditingController brandTextController = TextEditingController();
  TextEditingController yearTextController = TextEditingController();
  TextEditingController fuelTextController = TextEditingController();
  TextEditingController kmDrivenTextController = TextEditingController();
  TextEditingController numOfOwnerTextController = TextEditingController();
  TextEditingController adTitleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Include Some Details",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload Images",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                openImagePicker();
              },
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
                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          image!,
                          fit: BoxFit.fill,
                        ))
                    : const Column(
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
            GestureDetector(
              onTap: () {
                openImagePicker();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 35),
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
                    borderRadius: BorderRadius.circular(10)),
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
              ),
            ),
            const Text(
              "Item Condition",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    currentIndex = 1;
                  },
                  child: Container(
                    width: 105,
                    height: 42,
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: currentIndex == 1
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.5)),
                      color: currentIndex == 1
                          ? Colors.black
                          : const Color(0xffFCFCFD),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                        child: Text(
                      "New",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: currentIndex == 1 ? Colors.white : Colors.black,
                      ),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    currentIndex = 2;
                  },
                  child: Container(
                    width: 105,
                    height: 42,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      color: currentIndex == 2
                          ? Colors.black
                          : const Color(0xffFCFCFD),
                      border: Border.all(
                          color: currentIndex == 2
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                        child: Text(
                      "Used",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: currentIndex == 2 ? Colors.white : Colors.black,
                      ),
                    )),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Brand",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
              TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Color(0xffFF385C),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ))
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
                controller: brandTextController,
                readOnly: true,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: "Select",
                  hintStyle:
                      const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: PopupMenuButton(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    onSelected: (String value) {
                      setState(() {
                        brandTextController.text = value;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return ['Brand 1', 'Brand 2', 'Brand 3'].map((option) {
                        return PopupMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList();
                    },
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s+")),
                  FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Year",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
              TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Color(0xffFF385C),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ))
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
                controller: yearTextController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s+")),
                  FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji)),
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4)
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Fuel",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
              TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Color(0xffFF385C),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ))
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
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
                controller: fuelTextController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s+")),
                  FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji)),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Transmission",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
              TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Color(0xffFF385C),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ))
            ])),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    transmission = 1;
                  },
                  child: Container(
                    width: 130,
                    height: 50,
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: transmission == 1
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.5)),
                      color: transmission == 1 ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                        child: Text(
                      "New",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: transmission == 1 ? Colors.white : Colors.black,
                      ),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    transmission = 2;
                  },
                  child: Container(
                    width: 130,
                    height: 50,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      color: transmission == 2 ? Colors.black : Colors.white,
                      border: Border.all(
                          color: transmission == 2
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                        child: Text(
                      "Used",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: transmission == 2 ? Colors.white : Colors.black,
                      ),
                    )),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "KM Driven",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
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
                controller: kmDrivenTextController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s+")),
                  FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji)),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "No. of Onwers",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
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
                controller: numOfOwnerTextController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s+")),
                  FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji)),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Ad Title",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
              TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Color(0xffFF385C),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ))
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
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
                controller: adTitleTextController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s+")),
                  FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Describe what you are selling",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                controller: descriptionTextController,
                maxLines: 5,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s+")),
                  FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Price (in EGP)",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
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
                controller: priceTextController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter Price",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s+")),
                  FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji)),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PostAddedFinalView()),
                );
              },
              child: Container(
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
                      fontWeight: FontWeight.w500),
                ),
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

  void openImagePicker() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => GestureDetector(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsetsDirectional.only(end: 70),
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              color: Color(0xffFF385C),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x194A841C),
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 19,
                                ),
                              ]),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 70, top: 10),
                          child: Text(
                            "Camera",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                  ),
                  GestureDetector(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              color: Color(0xffFF385C),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x194A841C),
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 19,
                                ),
                              ]),
                          child: const Icon(
                            Icons.image_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 5, top: 10),
                          child: Text(
                            "Gallery",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(13.0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusScopeNode());
        },
      ),
    );
  }
}
