import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/movies/data/repositories/movies_repository_impl.dart';
import '../../features/movies/data/services/tmdb_service.dart';
import '../../features/movies/domain/repositories/movies_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/services/tmdb_auth_service.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

// Ce provider sera override dans le main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw StateError(
  'sharedPreferencesProvider not initialized. Ensure you have overridden this provider in your ProviderScope.',
));

final tmdbServiceProvider = Provider<TMDBService>((ref) {
  return TMDBService(ref);
});

// Provider pour TMDBAuthService qui utilise la méthode de création asynchrone
final tmdbAuthServiceProvider = FutureProvider<TMDBAuthService>((ref) async {
  return await TMDBAuthService.create();
});

// Provider pour AuthRepository qui attend que TMDBAuthService soit initialisé
final authRepositoryProvider = FutureProvider<AuthRepository>((ref) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  final authService = await ref.watch(tmdbAuthServiceProvider.future);
  return AuthRepositoryImpl(prefs, authService);
});

final moviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  final tmdbService = ref.watch(tmdbServiceProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return MoviesRepositoryImpl(tmdbService, prefs);
}); 