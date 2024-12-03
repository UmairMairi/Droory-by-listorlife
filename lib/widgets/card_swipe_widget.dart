import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:list_and_life/widgets/image_zoom_screen.dart';

import '../res/assets_res.dart';

class CardSwipeWidget extends StatefulWidget {
  final double? height;
  final ProductDetailModel? data;
  final List<ProductMedias>? imagesList;
  final BorderRadiusGeometry? borderRadius;
  const CardSwipeWidget({
    super.key,
    required this.data,
    this.height,
    this.imagesList,
    this.borderRadius,
  });

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
    super.initState();
    bannerImages.insert(0, widget.data?.image);

    bannerImages =
        widget.data?.productMedias?.map((element) => element.media).toList() ??
            [];
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    setState(() {
      if (_currentPage == 0) {
        _currentPage = bannerImages.length - 1; // Go to last page if at first
      } else {
        _currentPage--;
      }
      _pageController.jumpToPage(_currentPage);
    });
  }

  void _goToNextPage() {
    setState(() {
      if (_currentPage == bannerImages.length - 1) {
        _currentPage = 0; // Go to first page if at last
      } else {
        _currentPage++;
      }
      _pageController.jumpToPage(_currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: widget.height ?? 250,
      width: context.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: bannerImages.length,
            itemBuilder: (context, index) {
              return ImageView.rect(
                image: "${ApiConstants.imageUrl}/${bannerImages[index]}",
                placeholder: AssetsRes.APP_LOGO,
                width: context.width,
                height: widget.height ?? 220,
                fit: BoxFit.fill,
                /*onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageViewer(
                            galleryItems:bannerImages))),*/
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageViewer(
                          pageController: _pageController,
                            initialIndex: index,
                            galleryItems:bannerImages))),
              );
            },
          ),
          Positioned(
            left: 0,
            child: IconButton(
              onPressed: _goToPreviousPage,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              onPressed: _goToNextPage,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(bottom: 0, child: _buildDots(context: context)),
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
  bool get wantKeepAlive => true;
}
