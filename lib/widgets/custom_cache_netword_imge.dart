import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:shimmer/shimmer.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final double? height;
  final double? width;
  final String? imageUrl;
  final BoxFit? cover;
  final double? borderRadius;
  const CustomCachedNetworkImage({
    super.key,
    this.height,
    this.width,
    this.imageUrl,
    this.cover = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.appColors.lightGrey,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppConstants.profilePhotoRadius,
          ),
        ),
        child: Icon(Icons.image_not_supported, color: context.appColors.grey),
      );
    }

    final screenSize = MediaQuery.sizeOf(context);
    final finiteMaxWidth =
        (width != null && width!.isFinite) ? width! : screenSize.width;
    final finiteMaxHeight =
        (height != null && height!.isFinite) ? height! : screenSize.height;

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      height: height,
      width: width ?? screenSize.width,
      fit: cover,
      maxWidthDiskCache: finiteMaxWidth.toInt(),
      maxHeightDiskCache: finiteMaxHeight.toInt(),
      memCacheWidth: finiteMaxWidth.toInt(),
      memCacheHeight: finiteMaxHeight.toInt(),
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppConstants.profilePhotoRadius,
            ),
            image: DecorationImage(image: imageProvider, fit: cover),
          ),
        );
      },
      progressIndicatorBuilder:
          (context, url, downloadProgress) => Shimmer.fromColors(
            baseColor: context.appColors.lightGrey,
            highlightColor: context.appColors.bubbleGray,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppConstants.profilePhotoRadius,
                ),
              ),
            ),
          ),
      errorWidget:
          (context, url, error) => Container(
            decoration: BoxDecoration(
              color: context.appColors.lightGrey,
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.profilePhotoRadius,
              ),
            ),
            width: width,
            height: height,
            child: Icon(Icons.error_outline, color: context.appColors.grey),
          ),
    );
  }
}
