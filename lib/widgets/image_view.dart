import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:shimmer/shimmer.dart';

import '../res/assets_res.dart';

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
  const ImageView.circle(
      {super.key,
      required this.image,
      this.progressSize,
      this.placeholder,
      this.borderWidth,
      this.borderColor,
      this.width,
      this.color,
      this.fit,
      this.isCircle = true,
      this.borderRadius,
      this.height});

  const ImageView.rect(
      {super.key,
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
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: !isCircle
          ? (image.isNotEmpty && !image.contains("http"))
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: FileImage(
                            File(image),
                          ),
                          fit: BoxFit.cover)),
                )
              : (image.isNotEmpty && image.contains("http"))
                  ? CachedNetworkImage(
                      imageUrl: image,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            color: color ?? Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(borderRadius ?? 0),
                            border: Border.all(
                                color: borderColor ?? Colors.transparent),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: fit ?? BoxFit.fill,
                            ),
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.white,
                          child: Container(
                            height: context.height,
                            width: context.width,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    placeholder ?? AssetsRes.IC_IMAGE,
                                  ),
                                  fit: BoxFit.cover)),
                        );
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                placeholder ?? AssetsRes.IC_IMAGE,
                              ),
                              fit: BoxFit.cover)),
                    )
          : ClipOval(
              child: SizedBox(
                  height: context.height,
                  width: context.width,
                  child: (image.isNotEmpty && !image.contains("http"))
                      ? Container(
                          height: height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: FileImage(File(image)),
                                fit: BoxFit.cover),
                          ),
                        )
                      : (image.isNotEmpty && image.contains("http"))
                          ? CachedNetworkImage(
                              imageUrl: image,
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: color ?? Colors.transparent,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: fit ?? BoxFit.fill,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (context, url) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    height: context.height,
                                    width: context.width,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: AssetImage(
                                            placeholder ?? AssetsRes.IC_PROFILE,
                                          ),
                                          fit: BoxFit.cover)),
                                );
                              },
                            )
                          : Container(
                              height: context.height,
                              width: context.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        placeholder ?? AssetsRes.IC_PROFILE),
                                    fit: BoxFit.cover),
                              ),
                            )),
            ),
    );
  }
}
