import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/watchlist_provider.dart';

class WatchlistPage extends ConsumerStatefulWidget {
  const WatchlistPage({super.key});

  @override
  ConsumerState<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends ConsumerState<WatchlistPage> {
  @override
  void initState() {
    super.initState();
    // Charge la watchlist quand la page est initialisée
    Future.microtask(() => ref.read(watchlistProvider.notifier).loadWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final watchlistState = ref.watch(watchlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: user == null
          ? const Center(
              child: Text('Please log in to see your watchlist.'),
            )
          : watchlistState.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
              data: (movies) {
                if (movies.isEmpty) {
                  return const Center(
                    child: Text('Your watchlist is empty.'),
                  );
                }

                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return ListTile(
                      leading: movie.posterPath != null
                          ? Image.network(
                              'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                              width: 56,
                              height: 84,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 56,
                                height: 84,
                                color: Colors.grey,
                                child: const Icon(Icons.error),
                              ),
                            )
                          : Container(
                              width: 56,
                              height: 84,
                              color: Colors.grey,
                              child: const Icon(Icons.movie),
                            ),
                      title: Text(movie.title),
                      subtitle: movie.releaseDate != null
                          ? Text(movie.releaseDate!.substring(0, 4))
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          ref
                              .read(watchlistProvider.notifier)
                              .removeFromWatchlist(movie.id);
                        },
                      ),
                      onTap: () {
                        // Navigate to movie details
                        // context.push('/movie/${movie.id}');
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}