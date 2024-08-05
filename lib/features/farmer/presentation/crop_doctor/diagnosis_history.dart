import 'package:farmlynco/features/farmer/presentation/crop_doctor/provider/crop_diagnosis_provider.dart';
import 'package:farmlynco/shared/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmlynco/shared/common_widgets/custom_appbar.dart';
import 'dart:io';
import 'package:flutter_markdown/flutter_markdown.dart';

class DiagnosisHistory extends ConsumerWidget {
  const DiagnosisHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnoses = ref.watch(cropDiagnosisProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: "Diagnosis History"),
      body: diagnoses.isEmpty
          ? const Center(
              child: CustomText(
              body: "No History",
            ))
          : ListView.builder(
              itemCount: diagnoses.length,
              itemBuilder: (context, index) {
                final diagnosis = diagnoses[index];
                return Dismissible(
                  key: Key(diagnosis.id),
                  onDismissed: (direction) {
                    ref
                        .read(cropDiagnosisProvider.notifier)
                        .deleteDiagnosis(diagnosis.id);
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    leading: Image.file(
                      File(diagnosis.imagePath),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: const Text('Diagnosis Result'),
                    subtitle: Text(
                      diagnosis.diagnosis,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
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
                                      'Full Diagnosis Result',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: Markdown(
                                        data: diagnosis.diagnosis,
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
                    },
                  ),
                );
              },
            ),
    );
  }
}
