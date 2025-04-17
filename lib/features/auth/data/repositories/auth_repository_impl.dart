import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/tmdb_auth_service.dart';
import '../../../../core/constants/app_constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences _prefs;
  final TMDBAuthService _authService;
  static const String _userKey = 'user_data';

  AuthRepositoryImpl(this._prefs, this._authService);

  Future<void> _saveUser(User user) async {
    final jsonString = jsonEncode({
      'id': user.id,
      'username': user.username,
      'avatar': user.avatar,
      'session_id': user.sessionId,
      'guest_session_id': user.guestSessionId,
      'is_guest': user.isGuest,
    });
    await _prefs.setString(_userKey, jsonString);
  }

  String? _buildAvatarUrl(String? avatarPath) {
    if (avatarPath == null) return null;
    return 'https://image.tmdb.org/t/p/w200$avatarPath';
  }

  @override
  Future<Either<String, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final requestToken = await _authService.createRequestToken();
      final validatedToken = await _authService.createSessionWithLogin(
        username: email,
        password: password,
        requestToken: requestToken,
      );
      final sessionId = await _authService.createSession(validatedToken);
      final accountDetails = await _authService.getAccountDetails(sessionId);

      final avatarPath = accountDetails['avatar']?['tmdb']?['avatar_path'] as String?;
      
      final user = User(
        id: accountDetails['id'].toString(),
        username: accountDetails['username']?.toString() ?? email,
        avatar: _buildAvatarUrl(avatarPath),
        sessionId: sessionId,
        isGuest: false,
      );

      await _saveUser(user);
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, User>> register({
    required String email,
    required String password,
    required String username,
  }) async {
    return Left('La création de compte doit se faire sur le site TMDB');
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      final userJson = _prefs.getString(_userKey);
      if (userJson != null) {
        final userData = jsonDecode(userJson) as Map<String, dynamic>;
        final user = User.fromJson(userData);
        
        // Si l'utilisateur a une session standard (non-invité), supprimer la session sur le serveur
        if (!user.isGuest && user.sessionId != null) {
          await _authService.deleteSession(user.sessionId!);
        }
      }
      
      // Supprimer les données locales
      await _prefs.remove(_userKey);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, User?>> getCurrentUser() async {
    try {
      final userJson = _prefs.getString(_userKey);
      if (userJson == null) {
        return const Right(null);
      }

      try {
        final Map<String, dynamic> userData = jsonDecode(userJson) as Map<String, dynamic>;
        final user = User.fromJson(userData);
        return Right(user);
      } catch (e) {
        // Si la désérialisation échoue, on supprime les données corrompues
        await _prefs.remove(_userKey);
        return const Right(null);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> updateProfile({
    required String username,
    String? avatar,
  }) async {
    try {
      final result = await getCurrentUser();
      return result.fold(
        (error) => Left(error),
        (currentUser) async {
          if (currentUser == null) {
            return const Left('Aucun utilisateur connecté');
          }

          final updatedUser = currentUser.copyWith(
            username: username,
            avatar: avatar,
          );

          await _saveUser(updatedUser);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, User>> loginAsGuest() async {
    try {
      final guestSessionId = await _authService.createGuestSession();
      
      final user = User(
        id: 'guest',
        username: 'Invité',
        guestSessionId: guestSessionId,
        isGuest: true,
      );

      await _saveUser(user);
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }
} 