import 'package:farmlynco/features/farmer/domain/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Favorite extends StateNotifier<List<ProductModel>> {
  Favorite() : super([]) {
    // Load saved favorites when initializing
    loadFavorites();
  }

  static const String _key = 'favorites';

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_key);
    if (favoritesJson != null) {
      final List<dynamic> decodedList = jsonDecode(favoritesJson);
      state = decodedList.map((item) => ProductModel.fromJson(item)).toList();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList =
        jsonEncode(state.map((item) => item.toJson()).toList());
    await prefs.setString(_key, encodedList);
  }

  void toggleBookmark(ProductModel product) {
    final index =
        state.indexWhere((item) => item.productId == product.productId);
    if (index == -1) {
      state = [...state, product.copyWith(isBookmarked: true)];
    } else {
      state = [
        ...state.sublist(0, index),
        ...state.sublist(index + 1),
      ];
    }
    _saveFavorites();
  }

  void removeFromBookmark(ProductModel product) {
    state = state.where((p) => p != product).toList();
    _saveFavorites();
  }
}

final favoriteProvider =
    StateNotifierProvider<Favorite, List<ProductModel>>((ref) => Favorite());
