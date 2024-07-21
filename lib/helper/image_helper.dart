import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageViewHelper {
  ImageViewHelper._();

  static show(
      {required BuildContext context,
      required String url,
      BoxFit? fit,
      double? radius,
      ColorFilter? colorFilter,
      Widget? child}) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit ?? BoxFit.cover,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 10.r),
            image: DecorationImage(
              image: imageProvider,
              colorFilter: colorFilter ??
                  const ColorFilter.mode(
                      Color(0x52000000), BlendMode.colorBurn),
              fit: fit ?? BoxFit.cover,
            )),
        child: child,
      ),
      placeholder: (context, url) => Container(),
      errorWidget: (context, url, error) => const Icon(
        Icons.error_outline_outlined,
        color: Colors.red,
      ),
    );
  }
}
