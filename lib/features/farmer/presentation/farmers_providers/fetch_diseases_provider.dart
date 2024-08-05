import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/features/farmer/domain/common_disease_model.dart';
import 'package:farmlynco/features/farmer/domain/disease_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchDiseasesDetailProvider = StreamProvider<List<DiseaseModel>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final collection = firestore.collection("trending_diseases").snapshots();

  return collection.map((querySnapshot) {
    final diseases = querySnapshot.docs
        .map((doc) => DiseaseModel.fromSnapshot(doc))
        .toList();

    return diseases;
  });
});

final fetchCommonDiseasesDetailProvider =
    StreamProvider<List<CommonDiseaseModel>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final collection = firestore.collection("common_diseases").snapshots();

  return collection.map((querySnapshot) {
    final diseases = querySnapshot.docs
        .map((doc) => CommonDiseaseModel.fromSnapshot(doc))
        .toList();

    return diseases;
  });
});
