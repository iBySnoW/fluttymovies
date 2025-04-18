import 'package:flutter_test/flutter_test.dart';

// Modèle de film simplifié pour les tests
class Movie {
  final String id;
  final String title;
  final double rating;
  final List<String> genres;

  Movie({
    required this.id,
    required this.title,
    required this.rating,
    required this.genres,
  });
}

void main() {
  group('Movies Tests', () {
    test('Movie data parsing', () {
      final movieData = {
        'id': '123',
        'title': 'Test Movie',
        'rating': 8.5,
        'genres': ['Action', 'Adventure'],
      };
      
      final movie = Movie(
        id: movieData['id'] as String,
        title: movieData['title'] as String,
        rating: movieData['rating'] as double,
        genres: List<String>.from(movieData['genres'] as List),
      );
      
      expect(movie.id, '123');
      expect(movie.title, 'Test Movie');
      expect(movie.rating, 8.5);
      expect(movie.genres, ['Action', 'Adventure']);
    });

    test('Movie filtering', () {
      final movies = [
        Movie(id: '1', title: 'Action Movie', rating: 8.0, genres: ['Action']),
        Movie(id: '2', title: 'Comedy Movie', rating: 7.5, genres: ['Comedy']),
        Movie(id: '3', title: 'Action Comedy', rating: 8.5, genres: ['Action', 'Comedy']),
      ];
      
      // Filtrer les films d'action
      final actionMovies = movies.where((movie) => movie.genres.contains('Action')).toList();
      expect(actionMovies.length, 2);
      expect(actionMovies[0].title, 'Action Movie');
      expect(actionMovies[1].title, 'Action Comedy');
      
      // Filtrer les films avec une note supérieure à 8.0
      final highRatedMovies = movies.where((movie) => movie.rating > 8.0).toList();
      expect(highRatedMovies.length, 1);
      expect(highRatedMovies[0].title, 'Action Comedy');
    });
  });
} 