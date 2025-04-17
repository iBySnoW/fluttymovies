import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/watchlist_provider.dart';
import '../widgets/movie_grid.dart';

class WatchlistPage extends ConsumerStatefulWidget {
  const WatchlistPage({super.key});

  @override
  ConsumerState<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends ConsumerState<WatchlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(watchlistProvider.notifier).loadWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final watchlistState = ref.watch(watchlistProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('À voir'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onBackground,
      ),
      body: user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Veuillez vous connecter pour voir votre liste de films à voir',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.push('/login'),
                    icon: const Icon(Icons.login),
                    label: const Text('Se connecter'),
                  ),
                ],
              ),
            )
          : watchlistState.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Une erreur est survenue',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        ref.read(watchlistProvider.notifier).loadWatchlist();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
              data: (movies) => MovieGrid(
                movies: movies,
                onMovieRemove: (movie) {
                  ref.read(watchlistProvider.notifier).removeFromWatchlist(movie.id);
                },
                removeIcon: Icons.remove_circle_outline,
                removeIconColor: theme.colorScheme.error,
                emptyMessage: 'Votre liste de films à voir est vide.\nAjoutez des films en cliquant sur le bouton "À voir" 🎬',
              ),
            ),
    );
  }
}