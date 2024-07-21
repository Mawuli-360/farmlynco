import 'package:farmlynco/route/navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:farmlynco/core/constant/app_colors.dart';

class ReadDetailScreen extends ConsumerStatefulWidget {
  const ReadDetailScreen(
      {required this.image, required this.content, super.key});

  final String image;
  final String content;

  @override
  ConsumerState<ReadDetailScreen> createState() => _ReadDetailScreenState();
}

class _ReadDetailScreenState extends ConsumerState<ReadDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 286.h,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 250.h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 270.h,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(widget.image),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    left: 10.h,
                    child: IconButton.filledTonal(
                        color: Colors.white,
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigation.pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          size: 25.h,
                          color: AppColors.green,
                        )),
                  )
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child:
                      SingleChildScrollView(child: Html(data: widget.content)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
