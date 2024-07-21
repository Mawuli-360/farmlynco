import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveGridViewItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ResponsiveGridViewItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth =
        screenWidth > 600 ? screenWidth * 0.3 : screenWidth * 0.45;
    final imageHeight = itemWidth * 0.7;
    final buttonSize = itemWidth * 0.09;

    return Container(
      width: itemWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.h),
        color: const Color.fromARGB(91, 50, 137, 122),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.h),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60.h,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15.sp),
                    maxLines: 1,
                  ),
                  Text(
                    'Price: GHC${price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: CircleAvatar(
                    radius: buttonSize,
                    backgroundColor: Colors.green,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: CircleAvatar(
                    radius: buttonSize,
                    backgroundColor: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
