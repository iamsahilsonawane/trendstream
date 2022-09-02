import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchKeywordProvider =
    StateNotifierProvider<SearchKeywordNotifier, String>((ref) {
  return SearchKeywordNotifier();
});

class SearchKeywordNotifier extends StateNotifier<String> {
  SearchKeywordNotifier() : super("");

  void setKeyword(String keyword) {
    state = keyword;
  }
}
