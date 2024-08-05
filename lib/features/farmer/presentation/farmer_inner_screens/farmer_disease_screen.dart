import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/buyer/presentation/widgets/news_card.dart';
import 'package:farmlynco/features/farmer/presentation/farmer_inner_screens/farmer_inner_screens_widgets.dart/top_pick_card.dart';
import 'package:farmlynco/features/farmer/presentation/farmers_providers/fetch_diseases_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/util/custom_loading_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FarmerDiseaseScreen extends ConsumerStatefulWidget {
  const FarmerDiseaseScreen({super.key});

  @override
  ConsumerState<FarmerDiseaseScreen> createState() =>
      _FarmerDiseaseScreenState();
}

class _FarmerDiseaseScreenState extends ConsumerState<FarmerDiseaseScreen> {
  late PageController pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.7, initialPage: 1);
    pageController.addListener(() {
      setState(() {
        pageOffset = pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final disease = ref.watch(fetchDiseasesDetailProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Top Trending Disease",
      ),
      body: SizedBox(
        width: double.infinity,
        height: 1.sh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.verticalSpace,
              const CustomText(
                body: "Common Diseases",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.headerTitleColor,
                bottom: 10,
                left: 15,
              ),
              TopPickCard(
                pageController: pageController,
                pageOffset: pageOffset,
              ),
              const CustomText(
                body: "Disease Trending",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.headerTitleColor,
                bottom: 10,
                left: 15,
                top: 15,
              ),
              disease.when(
                  data: (data) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                         
                          return NewsCard(
                            image: data[index].image,
                            title: data[index].title,
                            content: data[index].content,
                          );
                        });
                  },
                  loading: () => const CustomLoadingScale(),
                  error: (error, stacktrace) =>
                      Center(child: CustomText(body: error.toString())))
            ],
          ),
        ),
      ),
    );
  }
}
