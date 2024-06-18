import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_and_life/res/assets_res.dart';

class ImageView extends StatelessWidget {
  final String image;
  final double? progressSize;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final Color? color;
  final BoxFit? fit;
  final String? placeholder;
  final bool isCircle;

  const ImageView.circle({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.progressSize,
    this.placeholder,
    this.borderWidth,
    this.borderColor,
    this.color,
    this.fit,
    this.isCircle = true,
    this.borderRadius,
  });

  const ImageView.rect({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.progressSize,
    this.placeholder,
    this.borderWidth,
    this.borderColor,
    this.color,
    this.fit,
    this.isCircle = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: _buildDecoration(),
      child: _buildImage(),
    );
  }

  /// Builds the decoration for the image container.
  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: isCircle ? null : BorderRadius.circular(borderRadius ?? 10),
      border: borderWidth != null && borderColor != null
          ? Border.all(color: borderColor!, width: borderWidth!)
          : null,
    );
  }

  /// Determines the type of image and builds the corresponding widget.
  Widget _buildImage() {
    if (image.isEmpty) {
      return _buildPlaceholder();
    } else if (_isNetworkImage(image)) {
      return _buildNetworkImage();
    } else if (_isFileImage(image)) {
      return _buildFileImage();
    } else {
      return _buildAssetImage();
    }
  }

  /// Checks if the image URL is a network image.
  bool _isNetworkImage(String url) {
    return url.startsWith('http');
  }

  /// Checks if the image path is a local file.
  bool _isFileImage(String path) {
    return File(path).existsSync();
  }

  /// Builds the network image with caching.
  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) {
        return _buildDecorationImage(imageProvider);
      },
      placeholder: (context, url) {
        return _buildLoadingPlaceholder();
      },
      errorWidget: (context, url, error) {
        return _buildPlaceholder();
      },
    );
  }

  /// Builds the image from a local file.
  Widget _buildFileImage() {
    return _buildDecorationImage(FileImage(File(image)));
  }

  /// Builds the image from an asset.
  Widget _buildAssetImage() {
    return _buildDecorationImage(AssetImage(image));
  }

  /// Applies common decoration settings to all image types.
  Widget _buildDecorationImage(ImageProvider imageProvider) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        image: DecorationImage(
          image: imageProvider,
          fit: fit ?? BoxFit.cover,
        ),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius:
            isCircle ? null : BorderRadius.circular(borderRadius ?? 10),
      ),
    );
  }

  /// Builds a shimmer effect placeholder.
  Widget _buildLoadingPlaceholder() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  /// Builds a placeholder image.
  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(placeholder ?? AssetsRes.IC_IMAGE_PLACEHOLDER),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
