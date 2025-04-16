import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/models/movie.dart';

class TMDBService {
  final Dio _dio;
  final String _apiKey;
  final String _baseUrl;

  TMDBService()
      : _dio = Dio(),
        _apiKey = dotenv.env['TMDB_API_KEY'] ?? '',
        _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? '';

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/movie/popular',
        queryParameters: {
          'api_key': _apiKey,
          'page': page,
          'language': 'fr-FR',
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw 'Erreur lors de la récupération des films populaires: $e';
    }
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/movie/now_playing',
        queryParameters: {
          'api_key': _apiKey,
          'page': page,
          'language': 'fr-FR',
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw 'Erreur lors de la récupération des films à l\'affiche: $e';
    }
  }

  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/movie/upcoming',
        queryParameters: {
          'api_key': _apiKey,
          'page': page,
          'language': 'fr-FR',
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw 'Erreur lors de la récupération des films à venir: $e';
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/search/movie',
        queryParameters: {
          'api_key': _apiKey,
          'query': query,
          'page': page,
          'language': 'fr-FR',
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw 'Erreur lors de la recherche des films: $e';
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/movie/$movieId',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'fr-FR',
        },
      );

      return Movie.fromJson(response.data);
    } catch (e) {
      throw 'Erreur lors de la récupération des détails du film: $e';
    }
  }

  Future<void> rateMovie(int movieId, double rating) async {
    try {
      await _dio.post(
        '$_baseUrl/movie/$movieId/rating',
        queryParameters: {
          'api_key': _apiKey,
        },
        data: {
          'value': rating,
        },
      );
    } catch (e) {
      throw 'Erreur lors de la notation du film: $e';
    }
  }
} 