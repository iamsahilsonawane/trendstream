import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/features/movies/constants.dart';
import 'package:latest_movies/features/movies/enums/search_type.dart';

final searchTypeProvider = StateProvider<SearchType>((ref) {
  return SearchType.all;
});

String getSearchTypeString(SearchType searchType) {
  switch (searchType) {
    case SearchType.all:
      return SearchTypeConstants.all;
    case SearchType.movies:
      return SearchTypeConstants.movie;
    case SearchType.tvShows:
      return SearchTypeConstants.tvShows;
    default:
      return SearchTypeConstants.movie;
  }
}

SearchType getSearchTypeFromString(String searchType) {
  switch (searchType) {
    case SearchTypeConstants.all:
      return SearchType.all;
    case SearchTypeConstants.movie:
      return SearchType.movies;
    case SearchTypeConstants.tvShows:
      return SearchType.tvShows;
    default:
      return SearchType.movies;
  }
}
