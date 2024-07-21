
import 'package:farmlynco/features/authentication/data/auth_repository.dart';
import 'package:farmlynco/features/farmer/presentation/news/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchNewsDetailProvider = StreamProvider<List<NewsFeedModel>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final collection = firestore.collection("news").snapshots();

  return collection.map((querySnapshot) {
    final news = querySnapshot.docs
        .map((doc) => NewsFeedModel.fromSnapshot(doc))
        .toList();

    return news;
  });
});
