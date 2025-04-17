import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../movies/presentation/providers/favorites_provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
      ),
      body: user == null
          ? const Center(
              child: Text('Veuillez vous connecter pour voir vos favoris.'),
            )
          : favoritesState.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Erreur: $error'),
              ),
              data: (movies) {
                if (movies.isEmpty) {
                  return const Center(
                    child: Text('Votre liste de favoris est vide.'),
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
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          ref
                              .read(favoritesProvider.notifier)
                              .removeFromFavorites(movie.id);
                        },
                      ),
                      onTap: () {
                        // Navigation vers les détails du film
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