import 'package:dartz/dartz.dart';
import '../models/user.dart';

abstract class AuthRepository {
  Future<Either<String, User>> login({
    required String username,
    required String password,
  });

  Future<Either<String, User>> register({
    required String username,
    required String password,
  });

  Future<Either<String, void>> logout();

  Future<Either<String, User?>> getCurrentUser();

  Future<Either<String, void>> updateProfile({
    required String username,
    String? avatar,
  });
} 