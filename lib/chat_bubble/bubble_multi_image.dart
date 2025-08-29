import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BubbleMultiImage extends StatelessWidget {
  final List<String> imageUrls;
  final bool isSender;
  final bool sent;
  final bool delivered;
  final bool seen;
  final String? createdAt;
  final bool timeStamp;
  final Color color;
  final double bubbleRadius;
  final String id;

  const BubbleMultiImage({
    Key? key,
    required this.imageUrls,
    required this.isSender,
    required this.id,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.createdAt,
    this.timeStamp = false,
    this.color = Colors.white70,
    this.bubbleRadius = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? stateIcon;
    Widget? timeStateIcon;

    if (sent) {
      stateIcon = const Icon(Icons.done, size: 15, color: Colors.grey);
    }
    if (delivered) {
      stateIcon = const Icon(Icons.done_all, size: 15, color: Colors.grey);
    }
    if (seen) {
      stateIcon = const Icon(Icons.done_all, size: 15, color: Colors.green);
    }
    if (timeStamp && createdAt != null) {
      timeStateIcon = Text(
        createdAt!,
        style: const TextStyle(fontSize: 8, color: Colors.white70),
      );
    }

    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isSender) const Expanded(child: SizedBox(width: 5)),
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(bubbleRadius),
                    topRight: Radius.circular(bubbleRadius),
                    bottomLeft: Radius.circular(isSender ? bubbleRadius : 0),
                    bottomRight: Radius.circular(isSender ? 0 : bubbleRadius),
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: _buildImageGrid(context),
              ),
              if (stateIcon != null || timeStateIcon != null)
                Positioned(
                  bottom: 4,
                  right: 6,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (timeStateIcon != null) timeStateIcon,
                        if (timeStateIcon != null && stateIcon != null)
                          const SizedBox(width: 5),
                        if (stateIcon != null) stateIcon,
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (!isSender) const Expanded(child: SizedBox(width: 5)),
      ],
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    final imageCount = imageUrls.length;

    if (imageCount == 1) {
      return SizedBox(
        height: 200,
        child: _buildSingleImage(context, imageUrls[0], 0),
      );
    } else if (imageCount == 2) {
      return SizedBox(
        height: 150,
        child: Row(
          children: [
            Expanded(child: _buildSingleImage(context, imageUrls[0], 0)),
            const SizedBox(width: 2),
            Expanded(child: _buildSingleImage(context, imageUrls[1], 1)),
          ],
        ),
      );
    } else if (imageCount == 3) {
      return SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildSingleImage(context, imageUrls[0], 0),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _buildSingleImage(context, imageUrls[1], 1)),
                  const SizedBox(height: 2),
                  Expanded(child: _buildSingleImage(context, imageUrls[2], 2)),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // 4 or more images - 2x2 grid
      return SizedBox(
        height: 240,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildSingleImage(context, imageUrls[0], 0)),
                  const SizedBox(width: 2),
                  Expanded(child: _buildSingleImage(context, imageUrls[1], 1)),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildSingleImage(context, imageUrls[2], 2)),
                  const SizedBox(width: 2),
                  Expanded(
                    child: imageCount > 4
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              _buildSingleImage(context, imageUrls[3], 3),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '+${imageCount - 4}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : _buildSingleImage(context, imageUrls[3], 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSingleImage(BuildContext context, String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImageGalleryView(
              imageUrls: imageUrls,
              initialIndex: index,
              heroTag: '$id-$index',
            ),
          ),
        );
      },
      child: Hero(
        tag: '$id-$index',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.error, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

// Keep the ImageGalleryView class as is...
// Image Gallery View for viewing multiple images
class ImageGalleryView extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String heroTag;

  const ImageGalleryView({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
    required this.heroTag,
  }) : super(key: key);

  @override
  _ImageGalleryViewState createState() => _ImageGalleryViewState();
}

class _ImageGalleryViewState extends State<ImageGalleryView> {
  late PageController _pageController;
  late int _currentIndex;
  late ScrollController _thumbnailController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _thumbnailController = ScrollController();

    // Scroll to show the initial image in thumbnail list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.imageUrls.length > 1) {
        _scrollToThumbnail(_currentIndex);
      }
    });
  }

  void _scrollToThumbnail(int index) {
    if (_thumbnailController.hasClients) {
      final double position = index * 70.0; // 60 width + 10 padding
      _thumbnailController.animateTo(
        position,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main image viewer
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Images with swipe
                    PageView.builder(
                      controller: _pageController,
                      itemCount: widget.imageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                        _scrollToThumbnail(index);
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Single tap to show/hide UI
                          },
                          child: InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: Center(
                              child: Hero(
                                tag: index == widget.initialIndex
                                    ? widget.heroTag
                                    : 'image-$index',
                                child: CachedNetworkImage(
                                  imageUrl: widget.imageUrls[index],
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Top bar with close button and counter
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Close button
                                IconButton(
                                  icon: Icon(Icons.close,
                                      color: Colors.white, size: 28),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                // Image counter
                                if (widget.imageUrls.length > 1)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${_currentIndex + 1} / ${widget.imageUrls.length}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                SizedBox(width: 48), // Balance the layout
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Thumbnail strip at bottom (only if multiple images)
              if (widget.imageUrls.length > 1)
                Container(
                  height: 80,
                  color: Colors.black87,
                  child: ListView.builder(
                    controller: _thumbnailController,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    itemCount: widget.imageUrls.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == _currentIndex;
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Opacity(
                              opacity: isSelected ? 1.0 : 0.6,
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrls[index],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[800],
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[800],
                                  child: Icon(Icons.error,
                                      size: 20, color: Colors.white54),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
