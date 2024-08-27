// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:farmlynco/features/authentication/presentation/farmer_registration_screen.dart';
// import 'package:farmlynco/route/navigation.dart';
// import 'package:farmlynco/util/show_toast.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:farmlynco/core/constant/app_colors.dart';
// import 'package:farmlynco/shared/common_widgets/custom_text.dart';
// import 'package:farmlynco/shared/common_widgets/primary_button.dart';

// class StoreSetup extends ConsumerStatefulWidget {
//   const StoreSetup({super.key});

//   @override
//   ConsumerState<StoreSetup> createState() => _StoreSetupState();
// }

// class _StoreSetupState extends ConsumerState<StoreSetup> {
//   final StoreSetupFormData formData = StoreSetupFormData();
//   bool imageUrl = false;
//   int currentBody = 0;

//   @override
//   Widget build(BuildContext context) {
//     List<StoreSetupData> storeSetupDatas = [
//       StoreSetupData(
//         title: "What do you sell?",
//         cardText: "Select all categories that represent the products you sell",
//         bodyBuilder: (formData) => SelectCategoryBody(formData: formData),
//       ),
//       // StoreSetupData(
//       //   title: "Let's add a picture to your store",
//       //   cardText:
//       //       "Customers can easily find your store when you have a profile picture",
//       //   bodyBuilder: (formData) => StoreImageBody(formData: formData),
//       // ),
//       StoreSetupData(
//         title: "Verify your identity",
//         cardText:
//             "Select one means of identification. farmlynco will verify you as a vendor this way.",
//         bodyBuilder: (formData) => VerifyIdentityBody(formData: formData),
//       ),
//       StoreSetupData(
//         title: "Describe your shop briefly",
//         cardText:
//             "Describing your store lets customers know what you are selling and the location can manually be edited.",
//         bodyBuilder: (formData) =>
//             StoreDescriptionAndLocationBody(formData: formData),
//       ),
//     ];
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             padding: EdgeInsets.only(left: 10.h),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.arrow_back_ios,
//               size: 25.h,
//               color: AppColors.green,
//             )),
//         automaticallyImplyLeading: false,
//       ),
//       body: SizedBox(
//         width: double.infinity,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 25.verticalSpace,
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const CustomText(
//                       body: "Set up your store",
//                       fontSize: 24,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     10.horizontalSpace,
//                     CustomText(
//                       body: "($currentBody/2)",
//                       fontSize: 18,
//                       color: Colors.grey,
//                     ),
//                   ],
//                 ),
//                 8.verticalSpace,
//                 CustomText(
//                   body: storeSetupDatas[currentBody].title,
//                   // fontSize: 24,
//                 ),
//                 40.verticalSpace,
//                 Container(
//                   color: AppColors.greenFade100,
//                   padding: EdgeInsets.all(10.h),
//                   child: CustomText(
//                     body: storeSetupDatas[currentBody].cardText,
//                     fontSize: 14,
//                   ),
//                 ),
//                 30.verticalSpace,
//                 SizedBox(
//                   height: 0.35.sh,
//                   child: PageView.builder(
//                     // physics: const NeverScrollableScrollPhysics(),
//                     onPageChanged: (value) {
//                       setState(() {
//                         currentBody = value;
//                       });
//                     },
//                     itemCount: storeSetupDatas.length,
//                     itemBuilder: (context, index) {
//                       return storeSetupDatas[currentBody].bodyBuilder(formData);
//                     },
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     PrimaryButton(
//                       onTap: () {
//                         if (currentBody == 0) {
//                           return;
//                         }
//                         setState(() {
//                           currentBody--;
//                         });
//                       },
//                       text: "Previous",
//                       width: 170.w,
//                       useStadiumBorder: false,
//                       borderColor: AppColors.green,
//                       color: Colors.transparent,
//                       childAtStart: true,
//                       child: Icon(
//                         Icons.arrow_back,
//                         size: 20.h,
//                       ),
//                     ),
//                     PrimaryButton(
//                       onTap: () {
//                         if (currentBody < storeSetupDatas.length - 1) {
//                           setState(() {
//                             currentBody++;
//                           });
//                         } else {
//                           if (formData.identityNumber.isEmpty ||
//                               formData.storeLocation.isEmpty ||
//                               formData.selectedCategories.isEmpty ||
//                               formData.storeDescription.isEmpty) {
//                             showToast(
//                                 "please make sure you fill and select all fields");
//                             return;
//                           }
//                           submitFormData();
//                         }
//                       },
//                       text: currentBody == storeSetupDatas.length - 1
//                           ? "Submit"
//                           : "Continue",
//                       textColor: Colors.white,
//                       useStadiumBorder: false,
//                       width: 170.w,
//                       child: Icon(
//                         Icons.arrow_forward,
//                         size: 20.h,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 // 150.verticalSpace,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void submitFormData() {
//     // Here you can handle the submission of the complete form data
//     Navigation.navigatePush(const FarmRegistrationScreen(
//         // formData: formData,
//         ));
//   }
// }

// class StoreDescriptionAndLocationBody extends StatefulWidget {
//   const StoreDescriptionAndLocationBody({
//     super.key,
//     required this.formData,
//   });
//   final StoreSetupFormData formData;

//   @override
//   _StoreDescriptionAndLocationBodyState createState() =>
//       _StoreDescriptionAndLocationBodyState();
// }

// class _StoreDescriptionAndLocationBodyState
//     extends State<StoreDescriptionAndLocationBody> {
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();

//   int _wordCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _descriptionController.text = widget.formData.storeDescription;
//     _locationController.text = widget.formData.storeLocation;
//     _descriptionController.addListener(_updateWordCount);
//   }

//   @override
//   void dispose() {
//     _descriptionController.removeListener(_updateWordCount);
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   void _updateWordCount() {
//     setState(() {
//       _wordCount = _descriptionController.text
//           .split(' ')
//           .where((word) => word.isNotEmpty)
//           .length;
//       if (_wordCount > 200) {
//         _descriptionController.text =
//             _descriptionController.text.split(' ').take(200).join(' ');
//         _descriptionController.selection = TextSelection.fromPosition(
//           TextPosition(offset: _descriptionController.text.length),
//         );
//         _wordCount = 200;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const CustomText(
//           body: "Describe your business briefly",
//           fontSize: 16,
//         ),
//         10.verticalSpace,
//         Container(
//           padding: EdgeInsets.all(10.r),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.r),
//             border: Border.all(color: Colors.grey),
//           ),
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _descriptionController,
//                 onChanged: (value) {
//                   widget.formData.storeDescription = value;
//                 },
//                 maxLines: 3,
//                 minLines: 3,
//                 cursorColor: AppColors.green,
//                 decoration: const InputDecoration(
//                   hintText: "Start typing your product description...",
//                   border: InputBorder.none,
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: CustomText(
//                   body: "$_wordCount/200",
//                   fontSize: 12,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         15.verticalSpace,
//         const CustomText(
//           body: "Your location",
//           fontSize: 16,
//         ),
//         10.verticalSpace,
//         Container(
//           padding: EdgeInsets.only(left: 10.h, right: 8.h),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.r),
//             border: Border.all(color: Colors.grey),
//           ),
//           child: TextFormField(
//             controller: _locationController,
//             maxLines: 1,
//             minLines: 1,
//             onChanged: (value) {
//               widget.formData.storeLocation = value;
//             },
//             cursorColor: AppColors.green,
//             decoration: const InputDecoration(
//               hintText: "Your location",
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // various set up body screens

// // class StoreImageBody extends StatelessWidget {
// //   const StoreImageBody({
// //     super.key,
// //     required this.formData,
// //   });

// //   final StoreSetupFormData formData;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         if (formData.storeImageUrl != null)
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               20.verticalSpace,
// //               const CustomText(
// //                 body: "Add image",
// //                 fontSize: 16,
// //               ),
// //               10.verticalSpace,
// //               SizedBox(
// //                 height: 160.h,
// //                 width: double.infinity,
// //                 child: DottedBorder(
// //                     strokeWidth: 1,
// //                     child: Center(
// //                       child: Row(
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(
// //                             Icons.add_photo_alternate_outlined,
// //                             size: 28.h,
// //                           ),
// //                           10.horizontalSpace,
// //                           const CustomText(
// //                               body: "Add image of your store", fontSize: 17)
// //                         ],
// //                       ),
// //                     )),
// //               ),
// //             ],
// //           ),

// //         30.verticalSpace,
// //         // product image
// //         if (formData.storeImageUrl == null)
// //           Align(
// //             alignment: Alignment.center,
// //             child: Stack(
// //               children: [
// //                 Positioned(
// //                   child: Stack(
// //                     alignment: Alignment.center,
// //                     children: [
// //                       SizedBox(
// //                         height: 190.h,
// //                         width: 330.h,
// //                       ),
// //                       Positioned(
// //                         child: Container(
// //                           height: 180.h,
// //                           width: 300.h,
// //                           decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(10.r),
// //                               border: Border.all(
// //                                   color:
// //                                       const Color.fromARGB(215, 169, 169, 169),
// //                                   width: 1),
// //                               image: const DecorationImage(
// //                                   fit: BoxFit.cover,
// //                                   image: CachedNetworkImageProvider(
// //                                       "https://www.un.org/africarenewal/sites/www.un.org.africarenewal/files/styles/ar_main_story_big_picture/public/00189603.jpg?itok=AWPQ_xcd"))),
// //                         ),
// //                       ),
// //                       Positioned(
// //                         top: 0.h,
// //                         right: 0.h,
// //                         child: IconButton(
// //                           onPressed: () {},
// //                           icon: Icon(Icons.delete,
// //                               size: 25.sp, color: Colors.red),
// //                           style: const ButtonStyle(
// //                             backgroundColor: WidgetStatePropertyAll(
// //                               Color.fromARGB(255, 255, 199, 210),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       Positioned(
// //                         top: 0.h,
// //                         left: 0.h,
// //                         child: IconButton(
// //                           onPressed: () {},
// //                           icon: Icon(
// //                             Icons.edit,
// //                             size: 25.sp,
// //                             color: AppColors.green,
// //                           ),
// //                           color: const Color.fromARGB(255, 237, 242, 241),
// //                           style: const ButtonStyle(
// //                             backgroundColor: WidgetStatePropertyAll(
// //                               Color.fromARGB(255, 179, 255, 231),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //       ],
// //     );
// //   }
// // }

// class VerifyIdentityBody extends ConsumerStatefulWidget {
//   final StoreSetupFormData formData;
//   const VerifyIdentityBody({super.key, required this.formData});

//   @override
//   ConsumerState<VerifyIdentityBody> createState() => _VerifyIdentityBodyState();
// }

// class _VerifyIdentityBodyState extends ConsumerState<VerifyIdentityBody> {
//   final TextEditingController _identityController = TextEditingController();

//   int selectedIndex = 0;
//   String selectedOption = "National Identity Number (NIN)";
//   List<String> identityOptions = [
//     "National Identity Number (NIN)",
//     "Permanent Voter's Card"
//   ];

//   @override
//   void initState() {
//     super.initState();
//     widget.formData.identityType = identityOptions[0];
//     _identityController.text = widget.formData.identityNumber;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 120.h,
//           child: ListView.separated(
//               itemBuilder: (context, index) {
//                 return _CardOption(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = index;
//                         selectedOption = identityOptions[index];
//                       });
//                     },
//                     title: identityOptions[index],
//                     isSelected: selectedIndex == index);
//               },
//               separatorBuilder: (_, index) => 10.verticalSpace,
//               itemCount: identityOptions.length),
//         ),
//         40.verticalSpace,
//         _NationalIdentityNumberField(
//           hintText: "Enter a valid number",
//           title: selectedOption,
//           textInputType: TextInputType.number,
//           onChanged: (value) {
//             widget.formData.identityNumber = value;
//           },
//           controller: _identityController,
//         )
//       ],
//     );
//   }
// }

// class SelectCategoryBody extends StatefulWidget {
//   final StoreSetupFormData formData;
//   const SelectCategoryBody({super.key, required this.formData});

//   @override
//   State<SelectCategoryBody> createState() => _SelectCategoryBodyState();
// }

// class _SelectCategoryBodyState extends State<SelectCategoryBody> {
//   List<String> categories = [
//     "Vegetables",
//     "Oil",
//     "Tubers",
//     "Fruits",
//     "Pepper",
//     "Legumes",
//     "Poultry",
//     "Grains",
//     "Nuts",
//     "Spices",
//     "Meat"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 30.h),
//       child: Wrap(
//         spacing: 16.h,
//         runSpacing: 15.h,
//         alignment: WrapAlignment.spaceEvenly,
//         children: categories.map((category) {
//           bool isSelected =
//               widget.formData.selectedCategories.contains(category);

//           return ActionChip(
//             onPressed: () {
//               setState(() {
//                 if (isSelected) {
//                   widget.formData.selectedCategories.remove(category);
//                 } else {
//                   widget.formData.selectedCategories.add(category);
//                 }
//               });
//             },
//             shape: StadiumBorder(
//                 side: BorderSide(
//                     color: isSelected
//                         ? AppColors.green
//                         : const Color.fromARGB(77, 0, 0, 0))),
//             backgroundColor: isSelected ? AppColors.greenFade100 : null,
//             label: CustomText(
//               body: category,
//               fontSize: 14,
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// class _CardOption extends StatelessWidget {
//   final VoidCallback? onTap;
//   final String title;
//   final bool isSelected;

//   const _CardOption(
//       {required this.onTap, required this.title, required this.isSelected});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 55.h,
//         decoration: BoxDecoration(
//             border: Border.all(color: AppColors.primaryColor),
//             color: isSelected
//                 ? const Color.fromARGB(83, 136, 219, 193)
//                 : AppColors.white,
//             borderRadius: BorderRadius.circular(10.r)),
//         child: Row(
//           children: [
//             20.horizontalSpace,
//             isSelected
//                 ? Container(
//                     height: 25.h,
//                     width: 25.h,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: AppColors.primaryColor,
//                     ),
//                     child: Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 16.h,
//                     ),
//                   )
//                 : Icon(
//                     Icons.circle_outlined,
//                     color: AppColors.primaryColor,
//                     size: 28.h,
//                   ),
//             10.horizontalSpace,
//             Text(
//               title,
//               style: TextStyle(fontSize: 16.sp),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _NationalIdentityNumberField extends StatelessWidget {
//   const _NationalIdentityNumberField({
//     super.key,
//     required this.title,
//     required this.hintText,
//     this.textInputType = TextInputType.text,
//     required this.controller,
//     required this.onChanged,
//   });

//   final String title;
//   final String hintText;
//   final TextInputType textInputType;
//   final TextEditingController controller;
//   final void Function(String) onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(body: title, fontSize: 17),
//         8.verticalSpace,
//         SizedBox(
//           height: 60.h,
//           child: TextFormField(
//             controller: controller,
//             keyboardType: textInputType,
//             // focusNode: FocusNode(),
//             onChanged: onChanged,
//             decoration: InputDecoration(
//               hintText: hintText,
//               border: const OutlineInputBorder(),
//               disabledBorder: InputBorder.none,
//               enabledBorder: const OutlineInputBorder(),
//               focusedBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.black),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class StoreSetupData {
//   final String title;
//   final String cardText;
//   final Widget Function(StoreSetupFormData) bodyBuilder;
//   StoreSetupData({
//     required this.title,
//     required this.cardText,
//     required this.bodyBuilder,
//   });
// }

// class StoreSetupFormData {
//   List<String> selectedCategories;
//   String identityType;
//   String identityNumber;
//   String storeDescription;
//   String storeLocation;

//   StoreSetupFormData({
//     List<String>? selectedCategories,
//     this.identityType = '',
//     this.identityNumber = '',
//     this.storeDescription = '',
//     this.storeLocation = '',
//   }) : selectedCategories = selectedCategories ?? [];
// }
