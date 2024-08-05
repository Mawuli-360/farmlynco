import 'dart:io';

import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/features/farmer/domain/product_model.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FarmEditScreen extends ConsumerStatefulWidget {
  const FarmEditScreen({super.key, required this.product});

  final ProductModel product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FarmEditScreenState();
}

class _FarmEditScreenState extends ConsumerState<FarmEditScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? _imageFile;

  Future<void> _updateProduct() async {
    try {
      // Update the product data in Cloud Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget
              .product.productId) // Replace with the actual product document ID
          .update({
        'name': nameController.text,
        'price': priceController.text,
        'description': descriptionController.text,
        // If the image hasn't changed, you can omit the 'imageUrl' field
      });

      // If the image has changed, update the image in Firebase Storage
      if (_imageFile != null) {
        // Upload the new image to Firebase Storage
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('product_images');
        Reference referenceImageToUpload =
            referenceDirImages.child(uniqueFileName);

        await referenceImageToUpload.putFile(_imageFile!);
        String newImageUrl = await referenceImageToUpload.getDownloadURL();

        // Update the 'imageUrl' field in Cloud Firestore
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.product.productId)
            .update({'imageUrl': newImageUrl});
      }

      // Show a success message or navigate back to the previous screen
      showToast("Product updated successfully");

      Navigation.pop();
    } catch (e) {
      // Handle any errors
      // print('Error updating product: $e');
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
        ],
      ),
    );

    if (imageSource != null) {
      final imagePicker = ImagePicker();
      final file = await imagePicker.pickImage(source: imageSource);
      if (file != null) {
        setState(() {
          _imageFile = File(file.path);
        });
      }
    }
  }

  Future<void> _loadImageFromUrl(String imageUrl) async {
    try {
      final imageFile = await downloadFile(imageUrl); // Define this function
      setState(() {
        _imageFile = imageFile;
      });
    } catch (e) {
      // print('Error loading image: $e');
    }
  }

// Define this function to download the image file from the given URL
  Future<File> downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/image.jpg');
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController =
        TextEditingController(text: widget.product.price.toString());
    descriptionController =
        TextEditingController(text: widget.product.description);
    // Initialize _imageFile with the product's image URL
    _loadImageFromUrl(widget.product.productImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Edit Product',
          style: TextStyle(fontSize: 15.sp),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: const BoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _imageFile == null
                  ? Container(
                      width: double.infinity,
                      height: 157,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 61, 170, 152),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 80.h,
                          width: 80.h,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              Icons.camera,
                              size: 40.h,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 170.w,
                            height: 100.h,
                          ),
                          Positioned(
                            top: 1.h,
                            left: 1.h,
                            child: Container(
                              width: 170.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_imageFile!),
                                    fit: BoxFit.fill),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _pickImage(context),
                            child: CircleAvatar(
                              radius: 20.h,
                              backgroundColor: AppColors.primaryColor,
                              child: const Center(
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
              18.verticalSpace,
              SizedBox(
                width: double.infinity,
                height: 400.h,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Product Name',
                        ),
                        obscureText: false,
                      ),
                    ),
                    18.verticalSpace,
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8, 0, 8, 0),
                            child: TextFormField(
                              controller: priceController,
                              decoration: const InputDecoration(
                                  labelText: 'Price',
                                  border: OutlineInputBorder()),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8, 0, 8, 0),
                            child: TextFormField(
                              obscureText: false,
                              decoration: const InputDecoration(
                                  labelText: '/bag',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    18.verticalSpace,
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                        ),
                        obscureText: false,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_imageFile != null &&
                      nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    _updateProduct();
                  }
                  // print(_imageFile.toString());
                  showToast("Fields are compulsory to filled");
                },
                child: Container(
                  width: 380.h,
                  height: 50.h,
                  decoration: const ShapeDecoration(
                      shape: StadiumBorder(), color: AppColors.primaryColor),
                  child: Center(
                    child: Text(
                      "Update Product",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
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
