import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TMDBAuthService {
  final Dio _dio;
  final String _baseUrl;
  final SharedPreferences _prefs;
  static const String _apiKeyKey = 'tmdb_api_key';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _sessionIdKey = 'session_id';

  TMDBAuthService()
      : _dio = Dio(),
        _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? '',
        _prefs = SharedPreferences.getInstance() as SharedPreferences;

  // Méthode pour initialiser correctement SharedPreferences
  static Future<TMDBAuthService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return TMDBAuthService._(prefs);
  }

  TMDBAuthService._(this._prefs)
      : _dio = Dio(),
        _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? '';

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

  bool _isTokenExpired() {
    final expiryString = _prefs.getString(_tokenExpiryKey);
    if (expiryString == null) return true;
    
    try {
      // Le format de date TMDB est "YYYY-MM-DD HH:mm:ss UTC"
      // On enlève "UTC" et on ajoute "Z" pour le format ISO
      final formattedDate = expiryString.replaceAll(' UTC', 'Z');
      final expiryDate = DateTime.parse(formattedDate);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      // En cas d'erreur de parsing, on considère le token comme expiré
      print('Erreur de parsing de la date d\'expiration: $e');
      return true;
    }
  }

  Future<void> _saveTokenExpiry(String expiresAt) async {
    // On sauvegarde la date telle quelle, sans modification
    await _prefs.setString(_tokenExpiryKey, expiresAt);
  }

  Future<String> createRequestToken() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/authentication/token/new',
        queryParameters: {
          'api_key': _apiKey,
        },
      );

      final token = response.data['request_token'] as String;
      final expiresAt = response.data['expires_at'] as String;
      await _saveTokenExpiry(expiresAt);
      
      return token;
    } catch (e) {
      throw 'Erreur lors de la création du token de requête: $e';
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await _dio.delete(
        '$_baseUrl/authentication/session',
        queryParameters: {
          'api_key': _apiKey,
        },
        data: {
          'session_id': sessionId,
        },
      );
      
      // Nettoyer les données locales
      await Future.wait([
        _prefs.remove(_sessionIdKey),
        _prefs.remove(_tokenExpiryKey),
      ]);
    } catch (e) {
      throw 'Erreur lors de la suppression de la session: $e';
    }
  }

  Future<String> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    if (_isTokenExpired()) {
      throw 'Le token de requête a expiré. Veuillez réessayer.';
    }

    try {
      final response = await _dio.post(
        '$_baseUrl/authentication/token/validate_with_login',
        queryParameters: {
          'api_key': _apiKey,
        },
        data: {
          'username': username,
          'password': password,
          'request_token': requestToken,
        },
      );

      return response.data['request_token'] as String;
    } catch (e) {
      throw 'Erreur lors de la validation du token avec login: $e';
    }
  }

  Future<String> createSession(String requestToken) async {
    if (_isTokenExpired()) {
      throw 'Le token de requête a expiré. Veuillez réessayer.';
    }

    try {
      final response = await _dio.post(
        '$_baseUrl/authentication/session/new',
        queryParameters: {
          'api_key': _apiKey,
        },
        data: {
          'request_token': requestToken,
        },
      );

      final sessionId = response.data['session_id'] as String;
      await _prefs.setString(_sessionIdKey, sessionId);
      return sessionId;
    } catch (e) {
      throw 'Erreur lors de la création de la session: $e';
    }
  }

  Future<String> createGuestSession() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/authentication/guest_session/new',
        queryParameters: {
          'api_key': _apiKey,
        },
      );

      return response.data['guest_session_id'] as String;
    } catch (e) {
      throw 'Erreur lors de la création de la session invité: $e';
    }
  }

  Future<Map<String, dynamic>> getAccountDetails(String sessionId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/account',
        queryParameters: {
          'api_key': _apiKey,
          'session_id': sessionId,
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw 'Erreur lors de la récupération des détails du compte: $e';
    }
  }
} 