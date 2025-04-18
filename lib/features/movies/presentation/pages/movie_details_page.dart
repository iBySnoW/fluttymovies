import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/movies_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/watchlist_provider.dart';
import '../../../recommendations/presentation/widgets/recommendations_section.dart';

class MovieDetailsPage extends ConsumerStatefulWidget {
  final String movieId;

  const MovieDetailsPage({
    super.key,
    required this.movieId,
  });

  @override
  ConsumerState<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> {
  bool isFavorite = false;
  bool isInWatchlist = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    final favoriteStatus = await ref.read(favoritesProvider.notifier).isFavorite(int.parse(widget.movieId));
    final watchlistStatus = await ref.read(watchlistProvider.notifier).isInWatchlist(int.parse(widget.movieId));
    setState(() {
      isFavorite = favoriteStatus;
      isInWatchlist = watchlistStatus;
    });
  }

  Future<void> addToWatchlist(String? sessionId) async {
    if (sessionId == null) return;
    
    try {
      if (isInWatchlist) {
        await ref.read(watchlistProvider.notifier).removeFromWatchlist(int.parse(widget.movieId));
      } else {
        await ref.read(watchlistProvider.notifier).addToWatchlist(int.parse(widget.movieId));
      }
      await _checkStatus();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isInWatchlist ? 'Retiré de la watchlist' : 'Ajouté à la watchlist',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Une erreur est survenue',
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final movieState = ref.watch(movieDetailsProvider(int.parse(widget.movieId)));
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
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 400,
              pinned: true,
              stretch: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'movie_${movie.id}',
                      child: CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/original${movie.backdropPath}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
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
                            theme.colorScheme.background,
                          ],
                          stops: const [0.4, 0.75, 1.0],
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'poster_${movie.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: 'https://image.tmdb.org/t/p/w342${movie.posterPath}',
                              width: 120,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.onBackground,
                                  fontWeight: FontWeight.bold,
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
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${movie.voteCount} votes)',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Synopsis',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.8),
                        height: 1.5,
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
                              fontWeight: FontWeight.bold,
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
                              ref.read(movieDetailsProvider(int.parse(widget.movieId)).notifier)
                                  .rateMovie(rating * 2);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    RecommendationsSection(movieId: movie.id),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: movieState.whenOrNull(
        data: (movie) => FloatingActionButton(
          onPressed: () async {
            try {
              if (isFavorite) {
                await ref.read(favoritesProvider.notifier).removeFromFavorites(movie.id);
              } else {
                await ref.read(favoritesProvider.notifier).addToFavorites(movie.id);
              }
              await _checkStatus();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite ? 'Ajouté aux favoris' : 'Retiré des favoris',
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Une erreur est survenue',
                      style: TextStyle(color: theme.colorScheme.onError),
                    ),
                    backgroundColor: theme.colorScheme.error,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          backgroundColor: isFavorite ? theme.colorScheme.error : theme.colorScheme.primary,
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      persistentFooterButtons: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton.icon(
            onPressed: () => addToWatchlist(user?.sessionId),
            icon: Icon(isInWatchlist ? Icons.remove_circle_outline : Icons.add_circle_outline),
            label: Text(isInWatchlist ? 'Retirer de la watchlist' : 'Ajouter à la watchlist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isInWatchlist ? theme.colorScheme.error : theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 