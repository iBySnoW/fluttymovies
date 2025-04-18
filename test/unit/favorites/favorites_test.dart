import 'package:flutter_test/flutter_test.dart';

// Modèle de film simplifié pour les tests
class Movie {
  final String id;
  final String title;

  Movie({
    required this.id,
    required this.title,
  });
}

// Gestionnaire de favoris simplifié pour les tests
class FavoritesManager {
  final List<Movie> _favorites = [];

  List<Movie> get favorites => List.unmodifiable(_favorites);

  void addToFavorites(Movie movie) {
    if (!_favorites.any((m) => m.id == movie.id)) {
      _favorites.add(movie);
    }
  }

  void removeFromFavorites(String movieId) {
    _favorites.removeWhere((movie) => movie.id == movieId);
  }

  bool isFavorite(String movieId) {
    return _favorites.any((movie) => movie.id == movieId);
  }
}

void main() {
  group('Favorites Tests', () {
    late FavoritesManager favoritesManager;
    late Movie movie1;
    late Movie movie2;

    setUp(() {
      favoritesManager = FavoritesManager();
      movie1 = Movie(id: '1', title: 'Movie 1');
      movie2 = Movie(id: '2', title: 'Movie 2');
    });

    test('Add to favorites', () {
      favoritesManager.addToFavorites(movie1);
      expect(favoritesManager.favorites.length, 1);
      expect(favoritesManager.favorites.first.id, '1');
      expect(favoritesManager.isFavorite('1'), true);
    });

    test('Remove from favorites', () {
      favoritesManager.addToFavorites(movie1);
      favoritesManager.addToFavorites(movie2);
      expect(favoritesManager.favorites.length, 2);
      
      favoritesManager.removeFromFavorites('1');
      expect(favoritesManager.favorites.length, 1);
      expect(favoritesManager.favorites.first.id, '2');
      expect(favoritesManager.isFavorite('1'), false);
      expect(favoritesManager.isFavorite('2'), true);
    });

    test('Prevent duplicate favorites', () {
      favoritesManager.addToFavorites(movie1);
      favoritesManager.addToFavorites(movie1); // Ajouter le même film deux fois
      expect(favoritesManager.favorites.length, 1); // Devrait toujours être 1
    });
  });
} 