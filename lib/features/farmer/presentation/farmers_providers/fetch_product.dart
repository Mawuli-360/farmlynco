
import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/features/farmer/domain/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchProductProvider = StreamProvider<List<ProductModel>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final currentUserId = ref.watch(firebaseAuthProvider).currentUser!.uid;

  return firestore
      .collection("products")
      .where("userId", isEqualTo: currentUserId.toString())
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList());
});

final productCountProvider = StreamProvider<int>((ref) {
  final currentUserId = ref.watch(firebaseAuthProvider).currentUser!.uid;
  final firestore = ref.watch(firebaseFirestoreProvider);
  return firestore
      .collection('products')
      .where("userId", isEqualTo: currentUserId.toString())
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.length,
      );
});

