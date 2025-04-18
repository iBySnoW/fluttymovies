import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../movies/presentation/widgets/movie_card.dart';
import '../providers/recommendations_provider.dart';

class RecommendationsSection extends ConsumerWidget {
  final int movieId;
  final String title;

  const RecommendationsSection({
    Key? key,
    required this.movieId,
    this.title = 'Vous pourriez aimer',
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(movieRecommendationsProvider(movieId));

    return recommendationsAsync.when(
      data: (recommendations) {
        if (recommendations.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final movie = recommendations[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: SizedBox(
                      width: 180,
                      child: MovieCard(
                        movie: movie,
                        onTap: () {
                          // Navigation vers les détails du film
                          // TODO: Implémenter la navigation
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(
          'Erreur lors du chargement des recommandations: $error',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
      ),
    );
  }
} 