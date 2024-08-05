import 'package:farmlynco/features/buyer/presentation/inner_screens/read_detail_screen.dart';
import 'package:farmlynco/features/farmer/presentation/farmers_providers/fetch_diseases_provider.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart';

class TopPickCard extends ConsumerWidget {
  const TopPickCard({
    super.key,
    required this.pageController,
    required this.pageOffset,
  });

  final PageController pageController;
  final double pageOffset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commonDisease = ref.watch(fetchCommonDiseasesDetailProvider);

    return commonDisease.when(
        data: (data) {
          return SizedBox(
            height: 300.h,
            child: PageView.builder(
                itemCount: 3,
                controller: pageController,
                itemBuilder: (context, i) {
                  return parallaxCard(i, data[i].content, data[i].image);
                }),
          );
        },
        loading: () => const CustomLoadingScale(),
        error: (error, stacktrace) =>
            Center(child: CustomText(body: error.toString())));
  }

  Widget parallaxCard(int i, String body, String image) {
    final document = parse(body);
    final paragraphs = document.getElementsByTagName('p');
    final String plainText = paragraphs.isNotEmpty
        ? paragraphs.map((element) => element.text).join(' ')
        : '';
    return GestureDetector(
      onTap: () => Navigation.navigatePush(
          ReadDetailScreen(image: image, content: body)),
      child: Transform.scale(
        scale: 0.98,
        child: Container(
          padding: const EdgeInsets.only(right: 20),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(46, 0, 0, 0),
                          spreadRadius: 2.r,
                          blurRadius: 3.r)
                    ]),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      alignment: Alignment(-pageOffset.abs() + i, 0),
                      height: 280.h,
                      imageUrl: image,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10.h,
                bottom: 20.h,
                right: 10.h,
                child: Container(
                  padding: EdgeInsets.all(5.h),
                  margin: EdgeInsets.symmetric(horizontal: 3.h),
                  color: const Color.fromARGB(162, 255, 255, 255),
                  child: CustomText(
                    body: plainText,
                    fontSize: 16,
                    maxLines: 3,
                    textOverflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
