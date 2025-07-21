import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:list_and_life/widgets/image_zoom_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../res/assets_res.dart';

class CardSwipeWidget extends StatefulWidget {
  final double? height;
  final double? radius;
  final ProductDetailModel? data;
  final List<ProductMedias>? imagesList;
  final BorderRadiusGeometry? borderRadius;
  final String? screenType;
  final BoxFit? fit;
  final Function()? onItemTapped;

  const CardSwipeWidget({
    super.key,
    required this.data,
    this.height,
    this.imagesList,
    this.borderRadius,
    this.screenType,
    this.fit,
    this.onItemTapped,
    this.radius,
  });

  @override
  State<CardSwipeWidget> createState() => _CardSwipeWidgetState();
}

class _CardSwipeWidgetState extends State<CardSwipeWidget>
    with AutomaticKeepAliveClientMixin<CardSwipeWidget> {
  late List<String> bannerImages;
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    // gather images from passed list or model
    final src = widget.imagesList ?? widget.data?.productMedias ?? [];
    bannerImages = [];

    // primary image
    if ((widget.data?.image ?? '').trim().isNotEmpty) {
      bannerImages.add(widget.data!.image!);
    }

    // additional images
    for (var m in src) {
      final media = (m.media ?? '').trim();
      if (media.isNotEmpty) bannerImages.add(media);
    }

    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int? _normalizedCategoryId() {
    final raw = widget.data?.categoryId;
    if (raw == null) return null;
    if (raw is int) return raw;
    return int.tryParse(raw.toString());
  }

  String _placeholderFor(int? catId) {
    switch (catId) {
      case 8:
        return AssetsRes.SERVICE_FILLER_IMAGE;
      case 9:
        return AssetsRes.JOB_FILLER_IMAGE;
      default:
        return AssetsRes.APP_LOGO;
    }
  }

  bool _isCurrentLanguageArabic(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  String _getLocalizedCounter(int current, int total, BuildContext context) {
    if (_isCurrentLanguageArabic(context)) {
      // Convert to Arabic numerals
      String currentArabic = _convertToArabicNumerals(current.toString());
      String totalArabic = _convertToArabicNumerals(total.toString());
      return '$currentArabic/$totalArabic';
    } else {
      return '$current/$total';
    }
  }

  String _convertToArabicNumerals(String input) {
    const arabicNumerals = [
      '٠',
      '١',
      '٢',
      '٣',
      '٤',
      '٥',
      '٦',
      '٧',
      '٨',
      '٩',
      '١٠',
      '١١',
      '١٢',
      '١٣',
      '١٤',
      '١٥',
      '١٦',
      '١٧',
      '١٨',
      '١٩',
      '٢٠',
      '٢١',
      '٢٢',
      '٢٣',
      '٢٤',
      '٢٥',
      '٢٦',
      '٢ه',
      '٢٨',
      '٢٩',
      '٣٠'
    ];

    const englishNumerals = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30'
    ];

    String result = input;
    for (int i = 0; i < englishNumerals.length; i++) {
      result = result.replaceAll(englishNumerals[i], arabicNumerals[i]);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // filter out any empty or whitespace-only entries
    final validImages =
        bannerImages.where((img) => img.trim().isNotEmpty).toList();

    // No valid user images: show single filler asset
    if (validImages.isEmpty) {
      return SizedBox(
        height: widget.height ?? 300,
        width: context.width,
        child: ClipRRect(
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(widget.radius ?? 0),
          child: ImageView.rect(
            image: '',
            placeholder: _placeholderFor(_normalizedCategoryId()),
            width: context.width,
            height: widget.height ?? 270,
            fit: widget.fit ?? BoxFit.cover,
            onTap: widget.onItemTapped ?? () {},
          ),
        ),
      );
    }

    // At least one valid image: show carousel
    return SizedBox(
      height: widget.height ?? 300,
      width: context.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: validImages.length,
            itemBuilder: (context, i) {
              final url = validImages[i];
              return ClipRRect(
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(widget.radius ?? 0),
                child: ImageView.rect(
                  image: '${ApiConstants.imageUrl}/$url',
                  placeholder: _placeholderFor(_normalizedCategoryId()),
                  width: context.width,
                  height: widget.height ?? 270,
                  fit: widget.fit ?? BoxFit.cover,
                  onTap: widget.onItemTapped ??
                      () {
                        if ((widget.screenType ?? '').isEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ImageViewer(
                                pageController: _pageController,
                                initialIndex: i,
                                title: widget.data?.name ?? '',
                                galleryItems: validImages,
                              ),
                            ),
                          );
                        }
                      },
                ),
              );
            },
          ),

          // Image counter positioned based on language
          if (validImages.length > 1)
            Positioned(
              bottom: 20,
              left: _isCurrentLanguageArabic(context) ? null : 12,
              right: _isCurrentLanguageArabic(context) ? 12 : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getLocalizedCounter(
                          _currentPage + 1, validImages.length, context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Positioned(bottom: 0, child: _buildDots(context)),
        ],
      ),
    );
  }

  Widget _buildDots(BuildContext context) {
    final validImageCount =
        bannerImages.where((img) => img.trim().isNotEmpty).length;

    // Don't show dots if only one image
    if (validImageCount <= 1) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SmoothPageIndicator(
        controller: _pageController,
        count: validImageCount,
        effect: ScrollingDotsEffect(
          dotHeight: 8,
          dotWidth: 8,
          dotColor: Colors.white.withOpacity(0.5),
          activeDotColor: Colors.white,
        ),
        onDotClicked: (i) => setState(() => _pageController.jumpToPage(i)),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
