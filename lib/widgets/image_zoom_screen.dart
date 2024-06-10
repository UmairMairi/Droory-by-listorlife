import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
