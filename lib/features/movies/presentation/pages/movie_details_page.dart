import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/movies_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
class MovieDetailsPage extends ConsumerWidget {
  final String movieId;

  const MovieDetailsPage({
    super.key,
    required this.movieId,
  });

  Future<void> addToWatchlist(String? sessionId) async {
    final url = Uri.parse('https://api.themoviedb.org/3/account/20897079/watchlist?api_key=f6e398159b3ea651144af15fadbd39ea&session_id=$sessionId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json;charset=utf-8',
      },
      body: jsonEncode({
        "media_type": "movie",
        "media_id": int.parse(movieId),
        "watchlist": true,
      }),
    );

    if (response.statusCode == 201) {
      print('Ajouté à la watchlist !');
    } else {
      print('Erreur lors de l\'ajout à la watchlist: ${response.statusCode} - ${response.body}');
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
        final user = ref.watch(authStateProvider).value;
    final movieState = ref.watch(movieDetailsProvider(int.parse(movieId)));
    final favoriteMoviesState = ref.watch(favoriteMoviesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: movieState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Erreur: $error',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
        data: (movie) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/original${movie.backdropPath}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            theme.colorScheme.background.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppTheme.sunlightGold,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '(${movie.voteCount} votes)',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Date de sortie: ${movie.releaseDate}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Synopsis',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Noter ce film',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 16),
                          RatingBar.builder(
                            initialRating: movie.voteAverage / 2,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 40,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: AppTheme.sunlightGold,
                            ),
                            onRatingUpdate: (rating) {
                              ref.read(movieDetailsProvider(int.parse(movieId)).notifier)
                                  .rateMovie(rating * 2);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: movieState.whenOrNull(
        data: (movie) => favoriteMoviesState.whenOrNull(
          data: (favorites) {
            final isFavorite = favorites.any((m) => m.id == movie.id);
            return FloatingActionButton(
              onPressed: () {
                ref.read(favoritesProvider.notifier).addToFavorites(movie.id);
                print("Ajouté aux favoris: ${movie.title}");
              },
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: theme.colorScheme.onPrimary,
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () => addToWatchlist(user?.sessionId),
          child: const Text('Add to Watchlist'),
        ),
      ],
    );
  }
} 