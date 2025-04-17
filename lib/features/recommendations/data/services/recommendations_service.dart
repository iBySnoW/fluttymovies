import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../movies/domain/models/movie.dart';

class RecommendationsService {
  final Dio _dio;
  final String _baseUrl;
  final String _apiKey;

  RecommendationsService()
      : _dio = Dio(),
        _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? '',
        _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  Future<List<Movie>> getMovieRecommendations(int movieId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/movie/$movieId/recommendations',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'fr-FR',
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw 'Erreur lors de la récupération des recommandations: $e';
    }
  }
} 