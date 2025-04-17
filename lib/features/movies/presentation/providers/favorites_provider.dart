import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../movies/domain/models/movie.dart'; // Ajustez l'import selon votre structure

class FavoritesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final Ref ref;
  final Dio dio;

  FavoritesNotifier(this.ref, this.dio) : super(const AsyncValue.loading());

  Future<void> loadFavorites() async {
    try {
      state = const AsyncValue.loading();
      
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        state = const AsyncValue.data([]);
        return;
      }

      final accountId = user.id;
      final sessionId = user.sessionId;
      final apiKey = 'f6e398159b3ea651144af15fadbd39ea'; // Remplacez par votre API key ou utilisez une constante

      final response = await dio.get(
        'https://api.themoviedb.org/3/account/$accountId/favorite/movies',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        final List<Movie> movies = results.map((json) => Movie.fromJson(json)).toList();
        state = AsyncValue.data(movies);
      } else {
        state = AsyncValue.error(
          'Impossible de charger les favoris: ${response.statusCode}',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('Impossible de charger les favoris: $e', stackTrace);
    }
  }

  Future<void> addToFavorites(int movieId) async {
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      final accountId = user.id;
      final sessionId = user.sessionId;
      final apiKey = 'f6e398159b3ea651144af15fadbd39ea'; // Remplacez par votre API key

      await dio.post(
        'https://api.themoviedb.org/3/account/$accountId/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': true,
        },
      );

      // Recharger les favoris après l'ajout
      loadFavorites();
    } catch (e) {
      print('Impossible d\'ajouter aux favoris: $e');
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      final accountId = user.id;
      final sessionId = user.sessionId;
      final apiKey = 'f6e398159b3ea651144af15fadbd39ea'; // Remplacez par votre API key

      await dio.post(
        'https://api.themoviedb.org/3/account/$accountId/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': false,
        },
      );

      // Mettre à jour l'état directement pour supprimer le film
      state.whenData((movies) {
        state = AsyncValue.data(movies.where((movie) => movie.id != movieId).toList());
      });
    } catch (e) {
      print('Impossible de supprimer des favoris: $e');
    }
  }

  // Vérifier si un film est dans les favoris
  bool isFavorite(int movieId) {
    return state.maybeWhen(
      data: (movies) => movies.any((movie) => movie.id == movieId),
      orElse: () => false,
    );
  }
}

// Réutiliser le provider Dio existant ou en créer un nouveau si nécessaire
final dioProvider = Provider<Dio>((ref) => Dio());

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Movie>>>((ref) {
  final dio = ref.watch(dioProvider);
  return FavoritesNotifier(ref, dio);
});