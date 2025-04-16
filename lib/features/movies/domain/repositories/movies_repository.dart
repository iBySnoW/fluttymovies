import 'package:dartz/dartz.dart';
import '../models/movie.dart';

abstract class MoviesRepository {
  Future<Either<String, List<Movie>>> getPopularMovies({int page = 1});
  Future<Either<String, List<Movie>>> getNowPlayingMovies({int page = 1});
  Future<Either<String, List<Movie>>> getUpcomingMovies({int page = 1});
  Future<Either<String, List<Movie>>> searchMovies(String query, {int page = 1});
  Future<Either<String, Movie>> getMovieDetails(int movieId);
  Future<Either<String, void>> rateMovie(int movieId, double rating);
  
  // Méthodes pour la gestion des favoris
  Future<Either<String, void>> addToFavorites(int movieId);
  Future<Either<String, void>> removeFromFavorites(int movieId);
  Future<Either<String, List<Movie>>> getFavoriteMovies({int page = 1});
} 