import 'package:flutter_test/flutter_test.dart';

// Modèle de film simplifié pour les tests
class Movie {
  final String id;
  final String title;
  final List<String> genres;
  final double rating;

  Movie({
    required this.id,
    required this.title,
    required this.genres,
    required this.rating,
  });
}

// Gestionnaire de recommandations simplifié pour les tests
class RecommendationsManager {
  List<Movie> getRecommendations(List<Movie> allMovies, List<Movie> userFavorites) {
    if (userFavorites.isEmpty) return [];

    // Récupérer les genres préférés de l'utilisateur
    final preferredGenres = userFavorites
        .expand((movie) => movie.genres)
        .fold<Map<String, int>>({}, (map, genre) {
          map[genre] = (map[genre] ?? 0) + 1;
          return map;
        });

    // Trier les films par correspondance de genre et note
    final recommendations = allMovies
        .where((movie) => !userFavorites.any((fav) => fav.id == movie.id))
        .map((movie) {
          final genreScore = movie.genres
              .map((genre) => preferredGenres[genre] ?? 0)
              .fold<int>(0, (sum, count) => sum + count);
          return (movie, genreScore);
        })
        .where((tuple) => tuple.$2 > 0) // Au moins un genre en commun
        .toList()
      ..sort((a, b) {
        final genreComparison = b.$2.compareTo(a.$2);
        if (genreComparison != 0) return genreComparison;
        return b.$1.rating.compareTo(a.$1.rating);
      });

    return recommendations.map((tuple) => tuple.$1).toList();
  }
}

void main() {
  group('Recommendations Tests', () {
    late RecommendationsManager recommendationsManager;
    late List<Movie> allMovies;
    late List<Movie> userFavorites;

    setUp(() {
      recommendationsManager = RecommendationsManager();
      allMovies = [
        Movie(id: '1', title: 'Action Movie 1', genres: ['Action'], rating: 8.0),
        Movie(id: '2', title: 'Comedy 1', genres: ['Comedy'], rating: 7.5),
        Movie(id: '3', title: 'Action Movie 2', genres: ['Action'], rating: 7.0),
        Movie(id: '4', title: 'Action Comedy', genres: ['Action', 'Comedy'], rating: 8.5),
        Movie(id: '5', title: 'Drama 1', genres: ['Drama'], rating: 9.0),
      ];
    });

    test('Generate recommendations based on favorite genres', () {
      userFavorites = [
        Movie(id: '1', title: 'Action Movie 1', genres: ['Action'], rating: 8.0),
      ];

      final recommendations = recommendationsManager.getRecommendations(allMovies, userFavorites);
      
      expect(recommendations.length, 2);
      expect(recommendations[0].title, 'Action Comedy'); // Meilleure note + genre Action
      expect(recommendations[1].title, 'Action Movie 2'); // Genre Action
    });

    test('No recommendations without favorites', () {
      userFavorites = [];
      final recommendations = recommendationsManager.getRecommendations(allMovies, userFavorites);
      expect(recommendations.isEmpty, true);
    });

    test('Multiple genre preferences', () {
      userFavorites = [
        Movie(id: '1', title: 'Action Movie 1', genres: ['Action'], rating: 8.0),
        Movie(id: '2', title: 'Comedy 1', genres: ['Comedy'], rating: 7.5),
      ];

      final recommendations = recommendationsManager.getRecommendations(allMovies, userFavorites);
      
      expect(recommendations.length, 2);
      expect(recommendations[0].title, 'Action Comedy'); // Contient les deux genres préférés
      expect(recommendations[1].title, 'Action Movie 2'); // Contient un des genres préférés
    });
  });
} 