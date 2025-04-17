import 'package:dio/dio.dart';
import '../../movies/domain/models/movie.dart';

class RecommendationsRepository {
  final Dio _dio;

  RecommendationsRepository(this._dio);

  Future<List<Movie>> getMovieRecommendations(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId/recommendations');
      final results = response.data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch movie recommendations: $e');
    }
  }
} 