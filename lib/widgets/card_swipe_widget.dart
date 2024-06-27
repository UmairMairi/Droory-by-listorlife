import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/network/api_constants.dart';
import 'package:list_and_life/widgets/image_view.dart';

import '../res/assets_res.dart';

class CardSwipeWidget extends StatefulWidget {
  final double? height;
  final List<ProductMedias>? imagesList;
  final BorderRadiusGeometry? borderRadius;
  const CardSwipeWidget(
      {super.key, this.height, this.imagesList, this.borderRadius});

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
    bannerImages =
        widget.imagesList?.map((_element) => _element.media).toList() ?? [];
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
              return ClipRRect(
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(20),
                  child: ImageView.rect(
                    image: "${ApiConstants.imageUrl}/${bannerImages[index]}",
                    placeholder: AssetsRes.IC_IMAGE_PLACEHOLDER,
                    width: context.width,
                    height: widget.height ?? 220,
                    fit: BoxFit.fill,
                  ));
            }),
          ),
          _buildDots(),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: bannerImages.map((image) {
          int index = bannerImages.indexOf(image);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? context.theme.primaryColor
                  : Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
