import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../base/network/api_constants.dart';

class ImageZoomScreen extends StatelessWidget {
  final String imageUrl;

  const ImageZoomScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Explorer'),
          centerTitle: true,
        ),
        body: InteractiveViewer(
            minScale: 0.2,
            maxScale: 5.0,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )));
  }
}
//'https://fastly.picsum.photos/id/1/200/300.jpg?hmac=jH5bDkLr6Tgy3oAg5khKCHeunZMHq0ehBZr6vGifPLY'

class ImageViewer extends StatelessWidget {
  final List<String?> galleryItems;
  final PageController? pageController;
  final int? initialIndex;

  const ImageViewer(
      {super.key,
      required this.galleryItems,
      this.pageController,
      this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Explorer'),
          centerTitle: true,
        ),
        body: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(
                  "${ApiConstants.imageUrl}/${galleryItems[index] ?? ""}"),
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained,
              heroAttributes:
                  PhotoViewHeroAttributes(tag: galleryItems[index] ?? ""),
            );
          },
          itemCount: galleryItems.length,
          backgroundDecoration: BoxDecoration(
            color: Colors.white
          ),
          loadingBuilder: (context, event) => Center(
              child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded /
                      int.parse("${event.expectedTotalBytes}"),
            ),
          )),
          pageController: pageController,
          onPageChanged: (value) {},
        ));
  }
}
