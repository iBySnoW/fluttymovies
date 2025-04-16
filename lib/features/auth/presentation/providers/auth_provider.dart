import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/di/dependencies.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    state = const AsyncValue.loading();
    final result = await _repository.getCurrentUser();
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _repository.login(
      email: email,
      password: password,
    );
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }

  Future<void> register(String email, String password, String username) async {
    state = const AsyncValue.loading();
    final result = await _repository.register(
      email: email,
      password: password,
      username: username,
    );
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final result = await _repository.logout();
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }

  Future<void> updateProfile({required String username, String? avatar}) async {
    state = const AsyncValue.loading();
    final result = await _repository.updateProfile(
      username: username,
      avatar: avatar,
    );
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (_) => state.whenData((user) => user?.copyWith(
        username: username,
        avatar: avatar,
      )),
    );
  }
} 