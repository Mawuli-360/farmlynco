import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  bool isTabView = false;
  bool imageUrl = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigation.pop(),
              icon: Icon(
                Icons.arrow_back,
                size: 25.h,
                color: AppColors.green,
              )),
          title: const CustomText(body: "Add Product", fontSize: 18),
          automaticallyImplyLeading: false,
          centerTitle: true,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.h),
              child: Container(
                width: 340.w,
                color: Colors.transparent,
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: AppColors.green,
                  labelColor: AppColors.green,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: ["Product Info", "Description"]
                      .map((tab) => CustomText(body: tab, fontSize: 18))
                      .toList(),
                ),
              )),
        ),
        body: TabBarView(
          children: [
            // products info
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    const _AddFormField(
                      title: 'Product Name',
                      hintText: 'Egg',
                    ),
                    const _AddFormField(
                      title: 'Stock Quantity',
                      hintText: '50 crate',
                    ),
                    const _AddFormField(
                      title: 'Price (per unit)',
                      hintText: '250',
                      textInputType: TextInputType.number,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(body: "Category", fontSize: 17),
                          8.verticalSpace,
                          SizedBox(
                            height: 60.h,
                            child: DropdownButtonFormField(
                              value: "vegetable",
                              isExpanded: true,
                              alignment: Alignment.centerLeft,
                              items: ["vegetable", "Grain", "Fruit"]
                                  .map((item) => DropdownMenuItem(
                                        value: item,
                                        child: CustomText(
                                            body: item, fontSize: 16),
                                      ))
                                  .toList(),
                              onChanged: (value) {},
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                disabledBorder: InputBorder.none,
                                enabledBorder: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    50.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.h),
                      child: PrimaryButton(
                        onTap: () {},
                        text: "Next",
                        fontSize: 18,
                        textColor: Colors.white,
                        useStadiumBorder: false,
                      ),
                    )
                  ],
                ),
              ),
            ),

            // description view
            SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        const CustomText(
                          body: "Describe your product",
                          fontSize: 16,
                          // color: Colors.grey,
                        ),
                        10.verticalSpace,
                        Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: Colors.grey)),
                            child: Column(
                              children: [
                                TextFormField(
                                  maxLines: 5,
                                  minLines: 5,
                                  cursorColor: AppColors.green,
                                  decoration: const InputDecoration(
                                      hintText:
                                          "Start typing your product description...",
                                      border: InputBorder.none),
                                ),
                                const Align(
                                  alignment: Alignment.bottomRight,
                                  child: CustomText(
                                    body: "0/200",
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )),
                        if (!imageUrl)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              20.verticalSpace,
                              const CustomText(
                                body: "Add image",
                                fontSize: 16,
                                // color: Colors.grey,
                              ),
                              10.verticalSpace,
                              SizedBox(
                                width: double.infinity,
                                height: 50.h,
                                child: DottedBorder(
                                    strokeWidth: 1,
                                    child: Center(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 28.h,
                                          ),
                                          10.horizontalSpace,
                                          const CustomText(
                                              body: "Add image", fontSize: 17)
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),

                        20.verticalSpace,
                        // product image
                        if (imageUrl)
                          Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: 160.h,
                                        width: 160.h,
                                      ),
                                      Positioned(
                                        // left: 0.5.sw - 100.h,
                                        child: Container(
                                          height: 140.h,
                                          width: 140.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      215, 169, 169, 169),
                                                  width: 1),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color.fromARGB(
                                                          255, 0, 0, 0)
                                                      .withOpacity(0.25),
                                                  spreadRadius: 0,
                                                  blurRadius: 4,
                                                  offset: const Offset(0,
                                                      4), // changes position of shadow
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: CachedNetworkImageProvider(
                                                      "https://www.un.org/africarenewal/sites/www.un.org.africarenewal/files/styles/ar_main_story_big_picture/public/00189603.jpg?itok=AWPQ_xcd"))),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0.h,
                                        right: 0.h,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.delete,
                                              size: 25.sp, color: Colors.red),
                                          color: const Color.fromARGB(
                                              255, 237, 242, 241),
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                              Color.fromARGB(
                                                  255, 237, 242, 241),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0.h,
                                        left: 0.h,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.edit,
                                            size: 25.sp,
                                            color: AppColors.green,
                                          ),
                                          color: const Color.fromARGB(
                                              255, 237, 242, 241),
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                              Color.fromARGB(
                                                  255, 237, 242, 241),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        30.verticalSpace,
                        PrimaryButton(
                          onTap: () {},
                          text: "Save Product",
                          textColor: Colors.white,
                          useStadiumBorder: false,
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _AddFormField extends StatelessWidget {
  const _AddFormField({
    required this.title,
    required this.hintText,
    this.textInputType = TextInputType.text,
  });

  final String title;
  final String hintText;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.h, right: 12.h, bottom: 25.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(body: title, fontSize: 17),
          8.verticalSpace,
          SizedBox(
            height: 60.h,
            child: TextFormField(
              keyboardType: textInputType,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(),
                disabledBorder: InputBorder.none,
                enabledBorder: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
