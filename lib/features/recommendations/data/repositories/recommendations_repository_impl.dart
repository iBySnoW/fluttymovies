import 'package:dartz/dartz.dart';
import '../../../movies/domain/models/movie.dart';
import '../services/recommendations_service.dart';

class RecommendationsRepositoryImpl {
  final RecommendationsService _service;

  RecommendationsRepositoryImpl(this._service);

  Future<Either<String, List<Movie>>> getMovieRecommendations(int movieId) async {
    try {
      final recommendations = await _service.getMovieRecommendations(movieId);
      return Right(recommendations);
    } catch (e) {
      return Left(e.toString());
    }
  }
} 