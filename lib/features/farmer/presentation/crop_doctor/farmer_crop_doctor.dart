// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:farmlynco/core/constant/app_colors.dart';
import 'package:farmlynco/core/constant/app_images.dart';
import 'package:farmlynco/features/farmer/presentation/crop_doctor/diagnosis_history.dart';
import 'package:farmlynco/features/farmer/presentation/crop_doctor/provider/crop_diagnosis_provider.dart';
import 'package:farmlynco/route/navigation.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:farmlynco/shared/common_widgets/primary_button.dart';
import 'package:farmlynco/util/loading_overlay.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FarmerCropDoctor extends ConsumerWidget {
  const FarmerCropDoctor({super.key});

  Future<void> _pickImageAndUpload(BuildContext context, WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    final LoadingOverlay loadingOverlay = LoadingOverlay();

    final XFile? image = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose image source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () async {
                    Navigator.pop(context,
                        await picker.pickImage(source: ImageSource.gallery));
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () async {
                    Navigator.pop(context,
                        await picker.pickImage(source: ImageSource.camera));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (image != null) {
      try {
        loadingOverlay.show(context);

        File file = File(image.path);
        if (await file.exists()) {
          String diagnosis = await ref
              .read(cropDiagnosisProvider.notifier)
              .uploadImage(file.path);

          // Check if the request was cancelled
          if (diagnosis == 'Request was cancelled') {
            loadingOverlay.hide();
            return;
          }

          String formattedDiagnosis = formatDiagnosisAsMarkdown(diagnosis);

          ref
              .read(cropDiagnosisProvider.notifier)
              .addDiagnosis(file.path, formattedDiagnosis);

          loadingOverlay.hide();

          // Show the diagnosis in a modal bottom sheet
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.5,
                maxChildSize: 0.9,
                expand: false,
                builder: (_, controller) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Diagnosis Result',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Markdown(
                            data: formattedDiagnosis,
                            controller: controller,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          child: const Text('Close'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        } else {
          // print('File does not exist at path: ${file.path}');
          loadingOverlay.hide();
        }
      } on SocketException catch (_) {
        showToast("Network connection is bad");
        loadingOverlay.hide();
      } on TimeoutException catch (_) {
        showToast("Request timeout please try again later");

        loadingOverlay.hide();
      } catch (e) {
        showToast('Error accessing file: $e');
        loadingOverlay.hide();
      }
    }
  }

  String formatDiagnosisAsMarkdown(String rawDiagnosis) {
    return '''
$rawDiagnosis
''';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      onPopInvoked: (didPop){
          ref.read(cropDiagnosisProvider.notifier).cancelOngoingRequest();
      },
      child: Scaffold(
          appBar: CustomAppBar(
            title: "Crop Doctor",
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.history,
                  color: AppColors.primaryColor,
                ),
                onPressed: () {
                  Navigation.navigatePush(const DiagnosisHistory());
                },
              ),
            ],
          ),
          body: _buildInitialContent(context, ref)),
    );
  }

  SizedBox _buildInitialContent(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          55.verticalSpace,
          const CustomText(
            body:
                "Crop Doctor is an AI-powered tool that\nhelps farmers diagnose and\nmanage plant diseases.",
            fontSize: 16,
            textAlign: TextAlign.center,
          ),
          30.verticalSpace,
          const Image(image: AppImages.plantDiagnostic),
          70.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.h),
            child: PrimaryButton(
              onTap: () => _pickImageAndUpload(context, ref),
              text: "Take or upload picture of crop",
              textColor: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
