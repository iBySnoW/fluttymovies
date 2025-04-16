import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/movie.dart';
import '../../domain/repositories/movies_repository.dart';
import '../../../../core/di/dependencies.dart';

final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, AsyncValue<List<Movie>>>((ref) {
  return MoviesNotifier(ref.watch(moviesRepositoryProvider));
});

final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, AsyncValue<List<Movie>>>((ref) {
  return MoviesNotifier(ref.watch(moviesRepositoryProvider));
});

final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, AsyncValue<List<Movie>>>((ref) {
  return MoviesNotifier(ref.watch(moviesRepositoryProvider));
});

final movieDetailsProvider = StateNotifierProvider.family<MovieDetailsNotifier, AsyncValue<Movie>, int>((ref, movieId) {
  return MovieDetailsNotifier(ref.watch(moviesRepositoryProvider), movieId);
});

final favoriteMoviesProvider = StateNotifierProvider<MoviesNotifier, AsyncValue<List<Movie>>>((ref) {
  return MoviesNotifier(ref.watch(moviesRepositoryProvider));
});

class MoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final MoviesRepository _repository;
  int _page = 1;
  bool _hasMore = true;

  MoviesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadMovies();
  }

  Future<void> loadMovies() async {
    if (!_hasMore) return;

    state = const AsyncValue.loading();
    final result = await _repository.getPopularMovies(page: _page);
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (movies) {
        _hasMore = movies.isNotEmpty;
        _page++;
        return AsyncValue.data(movies);
      },
    );
  }

  Future<void> searchMovies(String query) async {
    state = const AsyncValue.loading();
    final result = await _repository.searchMovies(query);
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (movies) => AsyncValue.data(movies),
    );
  }

  Future<void> loadFavoriteMovies() async {
    state = const AsyncValue.loading();
    final result = await _repository.getFavoriteMovies();
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (movies) => AsyncValue.data(movies),
    );
  }

  Future<void> toggleFavorite(int movieId) async {
    final result = await _repository.toggleFavorite(movieId);
    result.fold(
      (error) => state = AsyncValue.error(error, StackTrace.current),
      (_) => loadFavoriteMovies(),
    );
  }
}

class MovieDetailsNotifier extends StateNotifier<AsyncValue<Movie>> {
  final MoviesRepository _repository;
  final int _movieId;

  MovieDetailsNotifier(this._repository, this._movieId) : super(const AsyncValue.loading()) {
    loadMovieDetails();
  }

  Future<void> loadMovieDetails() async {
    state = const AsyncValue.loading();
    final result = await _repository.getMovieDetails(_movieId);
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (movie) => AsyncValue.data(movie),
    );
  }

  Future<void> rateMovie(double rating) async {
    final result = await _repository.rateMovie(_movieId, rating);
    result.fold(
      (error) => state = AsyncValue.error(error, StackTrace.current),
      (_) => loadMovieDetails(),
    );
  }
} 