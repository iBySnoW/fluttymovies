import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/di/dependencies.dart';

// Provider pour l'état d'authentification
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  // Récupérer le repository depuis le FutureProvider
  final repositoryFuture = ref.watch(authRepositoryProvider.future);
  
  // Retourner un notifier qui sera initialisé une fois que le repository sera disponible
  return AuthNotifier(repositoryFuture);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final Future<AuthRepository> _repositoryFuture;

  AuthNotifier(this._repositoryFuture) : super(const AsyncValue.loading()) {
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    state = const AsyncValue.loading();
    try {
      final repository = await _repositoryFuture;
      final result = await repository.getCurrentUser();
      state = result.fold(
        (error) => AsyncValue.error(error, StackTrace.current),
        (user) => AsyncValue.data(user),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final repository = await _repositoryFuture;
      final result = await repository.login(
        username: email,
        password: password,
      );
      state = result.fold(
        (error) => AsyncValue.error(error, StackTrace.current),
        (user) => AsyncValue.data(user),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loginAsGuest() async {
    state = const AsyncValue.loading();
    try {
      final repository = await _repositoryFuture;
      final result = await (repository as AuthRepositoryImpl).loginAsGuest();
      state = result.fold(
        (error) => AsyncValue.error(error, StackTrace.current),
        (user) => AsyncValue.data(user),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> register(String email, String password, String username) async {
    state = const AsyncValue.loading();
    try {
      final repository = await _repositoryFuture;
      final result = await repository.register(
        username: username,
        password: password,
      );
      state = result.fold(
        (error) => AsyncValue.error(error, StackTrace.current),
        (user) => AsyncValue.data(user),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final repository = await _repositoryFuture;
      final result = await repository.logout();
      state = result.fold(
        (error) => AsyncValue.error(error, StackTrace.current),
        (_) => const AsyncValue.data(null),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile({
    required String username,
    String? avatar,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = await _repositoryFuture;
      final result = await repository.updateProfile(
        username: username,
        avatar: avatar,
      );
      state = result.fold(
        (error) => AsyncValue.error(error, StackTrace.current),
        (_) => state,
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
} 