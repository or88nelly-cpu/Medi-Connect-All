import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImageView extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final double? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomImageView({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imagePath.isEmpty) {
      imageWidget = errorWidget ?? const Icon(Icons.error_outline);
    } else if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) {
      if (imagePath.endsWith('.svg')) {
        imageWidget = SvgPicture.network(
          imagePath.trim(),
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        );
      } else {
        imageWidget = CachedNetworkImage(
          imageUrl: imagePath.trim(),
          width: width,
          height: height,
          fit: fit,
          color: color,
          placeholder: (context, url) =>
              placeholder ??
              const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          errorWidget: (context, url, error) =>
              errorWidget ?? const Icon(Icons.error_outline),
        );
      }
    } else if (imagePath.endsWith('.svg')) {
      imageWidget = SvgPicture.asset(
        imagePath.trim(),
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      );
    } else if (imagePath.contains('assets/')) {
      imageWidget = Image.asset(
        imagePath.trim(),
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    } else {
      imageWidget = Image.file(
        File(imagePath.trim()),
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    }

    if (borderRadius != null && borderRadius! > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
