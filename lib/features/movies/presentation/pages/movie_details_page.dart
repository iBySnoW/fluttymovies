import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/movies_provider.dart';

class MovieDetailsPage extends ConsumerWidget {
  final String movieId;

  const MovieDetailsPage({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieState = ref.watch(movieDetailsProvider(int.parse(movieId)));

    return Scaffold(
      body: movieState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (movie) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: '${AppConstants.imageBaseUrl}${movie.backdropPath}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error),
                  ),
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
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '(${movie.voteCount} votes)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Date de sortie: ${movie.releaseDate}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Synopsis',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Noter ce film',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          RatingBar.builder(
                            initialRating: movie.voteAverage / 2,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 40,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
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
        data: (movie) => FloatingActionButton(
          onPressed: () {
            ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie.id);
          },
          child: const Icon(Icons.favorite),
        ),
      ),
    );
  }
} 