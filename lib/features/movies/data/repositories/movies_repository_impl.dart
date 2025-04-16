import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/movie.dart';
import '../../domain/repositories/movies_repository.dart';
import '../services/tmdb_service.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final TMDBService _tmdbService;
  final SharedPreferences _prefs;
  static const String _favoritesKey = 'favorite_movies';

  MoviesRepositoryImpl(this._tmdbService, this._prefs);

  @override
  Future<Either<String, List<Movie>>> getPopularMovies({int page = 1}) async {
    try {
      final movies = await _tmdbService.getPopularMovies(page: page);
      return Right(movies);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Movie>>> getNowPlayingMovies({int page = 1}) async {
    try {
      final movies = await _tmdbService.getNowPlayingMovies(page: page);
      return Right(movies);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Movie>>> getUpcomingMovies({int page = 1}) async {
    try {
      final movies = await _tmdbService.getUpcomingMovies(page: page);
      return Right(movies);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Movie>>> searchMovies(String query, {int page = 1}) async {
    try {
      final movies = await _tmdbService.searchMovies(query, page: page);
      return Right(movies);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Movie>> getMovieDetails(int movieId) async {
    try {
      final movie = await _tmdbService.getMovieDetails(movieId);
      return Right(movie);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> addToFavorites(int movieId) async {
    try {
      final favorites = _prefs.getStringList(_favoritesKey) ?? [];
      if (!favorites.contains(movieId.toString())) {
        favorites.add(movieId.toString());
        await _prefs.setStringList(_favoritesKey, favorites);
      }
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> removeFromFavorites(int movieId) async {
    try {
      final favorites = _prefs.getStringList(_favoritesKey) ?? [];
      favorites.remove(movieId.toString());
      await _prefs.setStringList(_favoritesKey, favorites);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Movie>>> getFavoriteMovies({int page = 1}) async {
    try {
      final favorites = _prefs.getStringList(_favoritesKey) ?? [];
      final movies = <Movie>[];
      for (final movieId in favorites) {
        final movie = await _tmdbService.getMovieDetails(int.parse(movieId));
        movies.add(movie);
      }
      return Right(movies);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> rateMovie(int movieId, double rating) async {
    try {
      await _tmdbService.rateMovie(movieId, rating);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
} 