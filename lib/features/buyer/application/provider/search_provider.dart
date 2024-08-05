import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/features/farmer/domain/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider =
    Provider.family<List<ProductModel>, String>((ref, query) {
  final products = ref.watch(productSearchProvider);

  if (query.isEmpty) {
    return products.value ?? [];
  }

  final filteredProducts = products.value
      ?.where(
          (product) => product.name.toLowerCase().contains(query.toLowerCase()))
      .toList();

  return filteredProducts ?? [];
});

final productSearchProvider = StreamProvider<List<ProductModel>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final collectionRef = firestore.collection('products');

  return collectionRef.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList());
});

final selectedProductsProvider =
    StreamProvider.family<List<ProductModel>, String>((ref, filter) {
  final firestore = ref.watch(firebaseFirestoreProvider);

  // Check if the filter is "all" or a specific category
  final collection = (filter.toLowerCase() == 'all')
      ? firestore.collection("products").snapshots()
      : firestore
          .collection("products")
          .where("category", isEqualTo: filter.toLowerCase())
          .snapshots();

  return collection.map((querySnapshot) {
    final products = querySnapshot.docs
        .map((doc) => ProductModel.fromSnapshot(doc))
        .toList();

    if (filter.toLowerCase() != 'all') {
      products.shuffle();
    }

    return products;
  });
});
