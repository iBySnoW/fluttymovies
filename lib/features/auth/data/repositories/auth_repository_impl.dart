import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences _prefs;
  static const String _userKey = 'user_data';

  AuthRepositoryImpl(this._prefs);

  @override
  Future<Either<String, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Simuler une authentification réussie
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        username: email.split('@')[0],
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
    try {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        username: username,
      );
      
      await _saveUser(user);
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
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
      
      final user = User.fromJson(jsonDecode(userJson));
      return Right(user);
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
      final currentUserResult = await getCurrentUser();
      
      return currentUserResult.fold(
        (error) => Left(error),
        (currentUser) async {
          if (currentUser == null) {
            return const Left('Utilisateur non connecté');
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

  Future<void> _saveUser(User user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
} 