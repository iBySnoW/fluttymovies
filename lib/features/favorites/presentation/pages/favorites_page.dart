import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../movies/presentation/providers/movies_provider.dart';
import '../../../movies/presentation/widgets/movie_card.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(favoriteMoviesProvider.notifier).loadFavoriteMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoriteMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
      ),
      body: favoritesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (movies) {
          if (movies.isEmpty) {
            return const Center(
              child: Text('Vous n\'avez pas encore de films favoris'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                onTap: () => context.push('/movie/${movie.id}'),
              );
            },
          );
        },
      ),
    );
  }
} 