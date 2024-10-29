import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/widgets/image_view.dart';

import '../res/assets_res.dart';

class CardSwipeWidget extends StatefulWidget {
  final double? height;
  final ProductDetailModel? data;
  final List<ProductMedias>? imagesList;
  final BorderRadiusGeometry? borderRadius;
  const CardSwipeWidget(
      {super.key,
      required this.data,
      this.height,
      this.imagesList,
      this.borderRadius});

  @override
  State<CardSwipeWidget> createState() => _CardSwipeWidgetState();
}

class _CardSwipeWidgetState extends State<CardSwipeWidget>
    with AutomaticKeepAliveClientMixin<CardSwipeWidget> {
  List<String?> bannerImages = [];

  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState

    bannerImages.insert(0, widget.data?.image);

    bannerImages =
        widget.data?.productMedias?.map((element) => element.media).toList() ??
            [];

    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: widget.height ?? 220,
      width: context.width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: List.generate(bannerImages.length, (index) {
              log("${ApiConstants.imageUrl}/${bannerImages[index]}",
                  name: "Images");
              return ClipRRect(
                  child: ImageView.rect(
                image: "${ApiConstants.imageUrl}/${bannerImages[index]}",
                placeholder: AssetsRes.IC_IMAGE_PLACEHOLDER,
                width: context.width,
                height: widget.height ?? 220,
                fit: BoxFit.cover,
              ));
            }),
          ),
          _buildDots(context: context),
        ],
      ),
    );
  }

  Widget _buildDots({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(bannerImages.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey.withOpacity(0.8),
            ),
          );
        }),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
