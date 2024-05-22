import 'package:flutter/material.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/view/main/sell/mobile/include_mobile_detail_view.dart';

class MobileCategoryView extends StatefulWidget {
  const MobileCategoryView({super.key});

  @override
  State<MobileCategoryView> createState() => _MobileCategoryViewState();
}

class _MobileCategoryViewState extends State<MobileCategoryView> {
  List<Item> data = [
    Item(
      title: "Mobile Phones",
      image: AssetsRes.IC_CAT_MOBILE,
    ),
    Item(title: "Accessories", image: AssetsRes.IC_ACCESSORIES_IMAGE),
    Item(title: "Tablets", image: AssetsRes.IC_TABLET_IMAGE),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Mobiles",
        ),
      ),
      body: GridView.builder(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          shrinkWrap: true,
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              mainAxisExtent: 130),
          itemBuilder: (buildContext, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const IncludeMobileDetailView()),
                );
              },
              child: Card(
                color: const Color(0xffFCFCFD),
                elevation: 0.3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      data[index].image,
                      height: 38,
                      width: 46,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Text(
                      data[index].title,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class Item {
  String title = "";
  String image = "";

  Item({
    required this.title,
    required this.image,
  });
}
