import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/buyer/presentation/widgets/news_card.dart';
import 'package:farmlynco/shared/common_widgets/common_provider/news_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchNews = ref.watch(fetchNewsDetailProvider);

    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(title: "Top News"),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                15.verticalSpace,
                const CustomText(
                    body:
                        "Stay up-to-date on the latest news and \nupdates with our news feed.",
                    textAlign: TextAlign.center,
                    color: AppColors.primaryColor,
                    fontSize: 15),
                15.verticalSpace,
                Expanded(
                  child: fetchNews.when(
                      data: (data) {
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return NewsCard(
                                image: data[index].image,
                                title: data[index].title,
                                content: data[index].content,
                              );
                            });
                      },
                      error: (error, st) => Text(error.toString()),
                      loading: () => const Center(
                            child: CustomLoadingScale(),
                          )),
                ),
              ],
            ),
          ),
        ));
  }
}
