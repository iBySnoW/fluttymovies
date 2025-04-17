import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/movies/presentation/pages/home_page.dart';
import '../../features/movies/presentation/pages/movie_details_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Écouter l'état d'authentification
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // Si l'authentification est en cours de chargement, ne pas rediriger
      if (authState.isLoading) return null;
      
      // Récupérer l'utilisateur
      final user = authState.value;
      
      // Liste des routes publiques qui ne nécessitent pas d'authentification
      final publicRoutes = ['/login', '/register', '/movie'];
      
      // Si l'utilisateur n'est pas connecté
      if (user == null) {
        // Si la route actuelle est publique ou commence par une route publique, permettre l'accès
        if (publicRoutes.any((route) => state.matchedLocation.startsWith(route))) {
          return null;
        }
        // Sinon, rediriger vers la page de connexion
        return '/login';
      }
      
      // Si l'utilisateur est connecté et tente d'accéder à la page de connexion ou d'inscription
      if (state.matchedLocation == '/login' || state.matchedLocation == '/register') {
        return '/';
      }
      
      // Pas de redirection nécessaire
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/movie/:id',
        builder: (context, state) => MovieDetailsPage(
          movieId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}); 