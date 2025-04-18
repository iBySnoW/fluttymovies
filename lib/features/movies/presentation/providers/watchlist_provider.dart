import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../movies/domain/models/movie.dart'; // Ajustez l'import selon votre structure
import 'package:flutter_dotenv/flutter_dotenv.dart';

// État pour la watchlist
class WatchlistState {
  final List<Movie> movies;
  final bool isLoading;
  final String? error;

  WatchlistState({
    this.movies = const [],
    this.isLoading = false,
    this.error,
  });

  WatchlistState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? error,
  }) {
    return WatchlistState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class WatchlistNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final Ref ref;
  final Dio dio;

  WatchlistNotifier(this.ref, this.dio) : super(const AsyncValue.loading());

  Future<void> loadWatchlist() async {
    try {
      state = const AsyncValue.loading();
      
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        state = const AsyncValue.data([]);
        return;
      }

      final accountId = user.id;
      final sessionId = user.sessionId;
      final apiKey = dotenv.get('TMDB_API_KEY');

      final response = await dio.get(
        'https://api.themoviedb.org/3/account/$accountId/watchlist/movies',
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
          'Failed to load watchlist: ${response.statusCode}',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('Failed to load watchlist: $e', stackTrace);
    }
  }

  Future<void> addToWatchlist(int movieId) async {
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      final accountId = user.id;
      final sessionId = user.sessionId;
      final apiKey = dotenv.get('TMDB_API_KEY');

      await dio.post(
        'https://api.themoviedb.org/3/account/$accountId/watchlist',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'watchlist': true,
        },
      );

      // Reload watchlist after adding
      loadWatchlist();
    } catch (e) {
      print('Failed to add to watchlist: $e');
    }
  }

  Future<void> removeFromWatchlist(int movieId) async {
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      final accountId = user.id;
      final sessionId = user.sessionId;
      final apiKey = dotenv.get('TMDB_API_KEY');

      await dio.post(
        'https://api.themoviedb.org/3/account/$accountId/watchlist',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'watchlist': false,
        },
      );

      // Update state directly to remove movie
      state.whenData((movies) {
        state = AsyncValue.data(movies.where((movie) => movie.id != movieId).toList());
      });
    } catch (e) {
      print('Failed to remove from watchlist: $e');
    }
  }

  Future<bool> checkWatchlistStatus(int movieId) async {
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return false;

      final sessionId = user.sessionId;
      final apiKey = dotenv.get('TMDB_API_KEY');

      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/$movieId/account_states',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
      );

      if (response.statusCode == 200) {
        return response.data['watchlist'] ?? false;
      }
      return false;
    } catch (e) {
      print('Erreur lors de la vérification du statut watchlist: $e');
      return false;
    }
  }

  // Vérifier si un film est dans la watchlist
  Future<bool> isInWatchlist(int movieId) async {
    return await checkWatchlistStatus(movieId);
  }
}

final dioProvider = Provider<Dio>((ref) => Dio());

final watchlistProvider = StateNotifierProvider<WatchlistNotifier, AsyncValue<List<Movie>>>((ref) {
  final dio = ref.watch(dioProvider);
  return WatchlistNotifier(ref, dio);
});