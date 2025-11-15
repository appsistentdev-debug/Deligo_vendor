import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final double? radius;
  final BoxFit? fit;

  CachedImage(
    this.image, {
    this.height,
    this.width,
    this.radius,
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    return image != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 4),
            child: CachedNetworkImage(
              imageUrl: image!,
              height: height ?? 70,
              width: width ?? 70,
              fit: fit,
              errorWidget: (context, img, d) => Image.asset(
                'assets/empty_image.png',
                height: height ?? 70,
                width: width ?? 70,
              ),
              placeholder: (context, string) => Image.asset(
                'assets/empty_image.png',
                height: height ?? 70,
                width: width ?? 70,
              ),
            ),
          )
        : Image.asset(
            'assets/empty_image.png',
            height: height ?? 70,
            width: width ?? 70,
          );
  }
}
