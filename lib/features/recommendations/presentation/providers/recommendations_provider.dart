import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/recommendations_repository_impl.dart';
import '../../data/services/recommendations_service.dart';
import '../../../movies/domain/models/movie.dart';

final recommendationsServiceProvider = Provider<RecommendationsService>((ref) {
  return RecommendationsService();
});

final recommendationsRepositoryProvider = Provider<RecommendationsRepositoryImpl>((ref) {
  final service = ref.watch(recommendationsServiceProvider);
  return RecommendationsRepositoryImpl(service);
});

final movieRecommendationsProvider = FutureProvider.family<List<Movie>, int>((ref, movieId) async {
  final repository = ref.watch(recommendationsRepositoryProvider);
  final result = await repository.getMovieRecommendations(movieId);
  return result.fold(
    (error) => throw error,
    (recommendations) => recommendations,
  );
}); 