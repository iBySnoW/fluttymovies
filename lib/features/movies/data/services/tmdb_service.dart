import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/dependencies.dart';
import '../../../auth/domain/models/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/movie.dart';

class TMDBService {
  final Dio _dio;
  final String _baseUrl;
  final ProviderRef _ref;
  final SharedPreferences _prefs;
  static const String _apiKeyKey = 'tmdb_api_key';
  static const String _accountIdKey = 'tmdb_account_id';

  TMDBService(this._ref)
      : _dio = Dio(),
        _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? '',
        _prefs = _ref.read(sharedPreferencesProvider);

  String get _apiKey {
    // Essayer d'abord de récupérer la clé depuis les préférences
    final storedKey = _prefs.getString(_apiKeyKey);
    if (storedKey != null && storedKey.isNotEmpty) {
      return storedKey;
    }
    
    // Sinon, utiliser la clé depuis le fichier .env
    final envKey = dotenv.env['TMDB_API_KEY'] ?? '';
    
    // Sauvegarder la clé dans les préférences pour une utilisation future
    if (envKey.isNotEmpty) {
      _prefs.setString(_apiKeyKey, envKey);
    }
    
    return envKey;
  }

  String? _getSessionId() {
    final authState = _ref.read(authStateProvider);
    final user = authState.value;
    if (user == null) return null;
    return user.isGuest ? user.guestSessionId : user.sessionId;
  }

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
      final sessionId = _getSessionId();
      if (sessionId == null) {
        throw 'Vous devez être connecté pour noter un film';
      }

      await _dio.post(
        '$_baseUrl/movie/$movieId/rating',
        queryParameters: {
          'api_key': _apiKey,
          'guest_session_id': sessionId,
        },
        data: {
          'value': rating,
        },
      );
    } catch (e) {
      throw 'Erreur lors de la notation du film: $e';
    }
  }

  Future<String?> _getAccountId() async {
    // Try to get from preferences first
    String? accountId = _prefs.getString(_accountIdKey);
    if (accountId != null) return accountId;

    // If not found, fetch from API
    final sessionId = _getSessionId();
    if (sessionId == null) return null;

    try {
      final response = await _dio.get(
        '$_baseUrl/account',
        queryParameters: {
          'api_key': _apiKey,
          'session_id': sessionId,
        },
      );

      accountId = response.data['id'].toString();
      // Save for future use
      await _prefs.setString(_accountIdKey, accountId);
      return accountId;
    } catch (e) {
      print('Error fetching account ID: $e');
      return null;
    }
  }

  Future<void> addToFavorites(int movieId) async {
    try {
      final sessionId = _getSessionId();
      if (sessionId == null) {
        throw 'Vous devez être connecté pour ajouter un film aux favoris';
      }

      final accountId = await _getAccountId();
      if (accountId == null) {
        throw 'Impossible de récupérer l\'ID du compte';
      }

      await _dio.post(
        '$_baseUrl/account/$accountId/favorite',
        queryParameters: {
          'api_key': _apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': true,
        },
      );
    } catch (e) {
      throw 'Erreur lors de l\'ajout aux favoris: $e';
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    try {
      final sessionId = _getSessionId();
      if (sessionId == null) {
        throw 'Vous devez être connecté pour supprimer un film des favoris';
      }

      final accountId = await _getAccountId();
      if (accountId == null) {
        throw 'Impossible de récupérer l\'ID du compte';
      }

      await _dio.post(
        '$_baseUrl/account/$accountId/favorite',
        queryParameters: {
          'api_key': _apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': false,
        },
      );
    } catch (e) {
      throw 'Erreur lors de la suppression des favoris: $e';
    }
  }

  Future<List<Movie>> getFavoriteMovies({int page = 1}) async {
    try {
      final sessionId = _getSessionId();
      if (sessionId == null) {
        throw 'Vous devez être connecté pour voir vos films favoris';
      }

      final accountId = await _getAccountId();
      if (accountId == null) {
        throw 'Impossible de récupérer l\'ID du compte';
      }

      final response = await _dio.get(
        '$_baseUrl/account/$accountId/favorite/movies',
        queryParameters: {
          'api_key': _apiKey,
          'session_id': sessionId,
          'page': page,
          'language': 'fr-FR',
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw 'Erreur lors de la récupération des films favoris: $e';
    }
  }
} 