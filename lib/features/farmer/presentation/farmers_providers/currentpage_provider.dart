import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentPageNotifier extends StateNotifier<int> {
  CurrentPageNotifier() : super(0);

  void setPage(int page) {
    state = page;
  }
}

final currentPageProvider = StateNotifierProvider<CurrentPageNotifier, int>((ref) {
  return CurrentPageNotifier();
});