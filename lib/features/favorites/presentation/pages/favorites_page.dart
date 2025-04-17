import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../movies/presentation/providers/favorites_provider.dart';
import '../../../movies/presentation/widgets/movie_grid.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Charge les favoris quand la page est initialisée
    Future.microtask(() => ref.read(favoritesProvider.notifier).loadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final favoritesState = ref.watch(favoritesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
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
                    'Veuillez vous connecter pour voir vos favoris',
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
          : favoritesState.when(
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
                        ref.read(favoritesProvider.notifier).loadFavorites();
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
                  ref.read(favoritesProvider.notifier).removeFromFavorites(movie.id);
                },
                removeIcon: Icons.favorite,
                removeIconColor: theme.colorScheme.error,
                emptyMessage: 'Votre liste de favoris est vide.\nAjoutez des films en cliquant sur le cœur ❤️',
              ),
            ),
    );
  }
}