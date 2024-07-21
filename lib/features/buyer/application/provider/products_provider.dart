
import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/features/farmer/domain/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchSomeProductProvider = StreamProvider<List<ProductModel>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final collection = firestore.collection("products").snapshots();

  return collection.map((querySnapshot) {
    final products = querySnapshot.docs
        .map((doc) => ProductModel.fromSnapshot(doc))
        .toList();

    products.shuffle();

    return products.take(3).toList();
  });
});

final fetchAllProductProvider = StreamProvider<List<ProductModel>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final collection = firestore.collection("products").snapshots();

  return collection.map((querySnapshot) {
    final products = querySnapshot.docs
        .map((doc) => ProductModel.fromSnapshot(doc))
        .toList();

    products.shuffle();

    return products;
  });
});
