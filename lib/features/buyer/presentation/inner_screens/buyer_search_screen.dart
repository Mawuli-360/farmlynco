import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class BuyerSearchScreen extends ConsumerStatefulWidget {
  const BuyerSearchScreen({super.key});

  @override
  ConsumerState<BuyerSearchScreen> createState() => _BuyerSearchScreenState();
}

class _BuyerSearchScreenState extends ConsumerState<BuyerSearchScreen> {
  bool isTabView = false;

  @override
  Widget build(BuildContext context) {
    List<TarBarItem> tabs = [
      const TarBarItem(text: "Products", count: "10"),
      const TarBarItem(text: "Vendors", count: "10"),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: IconButton.filledTonal(
              color: Colors.white,
              padding: EdgeInsets.zero,
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 233, 233, 233))),
              onPressed: () => Navigation.pop(),
              icon: Icon(
                Icons.arrow_back,
                size: 25.h,
                color: AppColors.green,
              )),
          title: SizedBox(
            width: 320.w,
            child: TextFormField(
              cursorColor: AppColors.green,
              decoration: InputDecoration(
                  fillColor: const Color.fromARGB(34, 158, 158, 158),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 9.h, horizontal: 10.h),
                  filled: true,
                  focusedBorder: InputBorder.none,
                  hintText: "Search for products....",
                  suffixIcon: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.close)),
                  border: InputBorder.none),
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.h),
              child: Container(
                width: 340.w,
                color: const Color.fromARGB(108, 255, 255, 255),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: AppColors.green,
                  labelColor: AppColors.green,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: tabs,
                ),
              )),
        ),
        body: isTabView
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/animations/search_anim.json",
                      height: 230.h,
                      // width: 300.h,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.h),
                      child: const CustomText(
                        body: "Start typing to search for products or vendors",
                        fontSize: 17,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    70.verticalSpace,
                  ],
                ),
              )
            : TabBarView(
                children: [
                  // products view
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          20.verticalSpace,
                          Padding(
                            padding: EdgeInsets.only(left: 15.h),
                            child: const CustomText(
                                body: '42 products found', fontSize: 18),
                          ),
                          20.verticalSpace,
                          GridView.builder(
                            padding: EdgeInsets.only(
                                bottom: 30.h, left: 8.h, right: 8.h),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 20.h,
                              childAspectRatio: 0.86,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (_, index) => Container(),
                            itemCount: 10,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // vendor view
                  SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            20.verticalSpace,
                            Padding(
                              padding: EdgeInsets.only(left: 15.h),
                              child: const CustomText(
                                  body: '42 vendors found', fontSize: 18),
                            ),
                            20.verticalSpace,
                            ListView.builder(
                              itemCount: 10,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) => GestureDetector(
                                onTap: () => Navigation.openViewStoreScreen(),
                                child: Container(
                                  width: double.infinity,
                                  height: 90.h,
                                  margin: EdgeInsets.only(
                                    bottom: 15.h,
                                    left: 15.h,
                                    right: 15.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(72, 97, 222, 166),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        child: const Image(
                                          height: double.infinity,
                                          // width: 90.h,
                                          image: CachedNetworkImageProvider(
                                              "https://www.thespruce.com/thmb/fghCcR0Sv_lrSIg1mVWS9U-b_ts=/4002x0/filters:no_upscale():max_bytes(150000):strip_icc()/how-to-grow-watermelons-1403491-hero-2d1ce0752fed4ed599db3ba3b231f8b7.jpg"),
                                        ),
                                      ),
                                      8.horizontalSpace,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.verified,
                                                color: Colors.blue,
                                                size: 22.h,
                                              ),
                                              6.horizontalSpace,
                                              const CustomText(
                                                  body: 'Musa store',
                                                  maxLines: 1,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  color: AppColors.primaryColor,
                                                  fontSize: 16),
                                            ],
                                          ),
                                          const CustomText(
                                              body: '42 vendors found',
                                              color: AppColors.primaryColor,
                                              maxLines: 1,
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                              fontSize: 16),
                                          Row(
                                            children: List.generate(
                                                5,
                                                (index) => const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    )),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              ),
      ),
    );
  }
}

class TarBarItem extends ConsumerWidget {
  const TarBarItem({
    super.key,
    required this.text,
    required this.count,
  });

  final String text;
  final String count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tab(
      // text: text,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(body: text, fontSize: 18),
          4.horizontalSpace,
          CustomText(body: "($count)", fontSize: 18),
        ],
      ),
    );
  }
}
