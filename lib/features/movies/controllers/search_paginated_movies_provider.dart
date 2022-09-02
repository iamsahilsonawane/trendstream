import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/models/paginated_response.dart';
import '../models/movie/movie.dart';
import '../repositories/movies_repository.dart';

class PaginatedSearchProviderArgs extends Equatable {
  final int page;
  final String query;
  const PaginatedSearchProviderArgs({required this.page, required this.query});

  @override
  List<Object?> get props => [page, query];
}

final paginatedSearchMoviesProvider = FutureProvider.family<
    PaginatedResponse<Movie>, PaginatedSearchProviderArgs>(
  (ref, args) async {
    final moviesRepository = ref.watch(moviesRepositoryProvider);
    //watch the query provider

    return moviesRepository.searchMovie(
      query: args.query,
      page: args.page + 1,
    );
  },
);
