class AppConstants {
  static const String appName = 'FluttyMovies';
  
  // API Constants
  static const String apiBaseUrl = String.fromEnvironment('TMDB_BASE_URL');
  static const String apiKey = String.fromEnvironment('TMDB_API_KEY');
  static const String imageBaseUrl = String.fromEnvironment('TMDB_IMAGE_BASE_URL');
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Route Names
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String movieDetailsRoute = '/movie/:id';
  static const String favoritesRoute = '/favorites';
  static const String profileRoute = '/profile';
} 