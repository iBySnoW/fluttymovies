import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/di/dependencies.dart';
import 'core/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'features/movies/presentation/pages/home_page.dart';
import 'features/movies/presentation/pages/movie_details_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/profile_page.dart';
import 'features/favorites/presentation/pages/favorites_page.dart';

// Provider pour gérer le thème
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(true); // true = dark mode

  void toggleTheme() {
    state = !state;
  }
}

void main() async {
  // Assurez-vous que Flutter est initialisé
  WidgetsFlutterBinding.ensureInitialized();
  
  // Chargez les variables d'environnement
  await dotenv.load(fileName: ".env");
  
  // Initialisez SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Lancez l'application avec le ProviderScope
  runApp(
    ProviderScope(
      overrides: [
        // Override le provider de SharedPreferences avec l'instance initialisée
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    
    // Attendre que les providers asynchrones soient initialisés
    final routerAsync = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'FluttyMovies',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: routerAsync,
      debugShowCheckedModeBanner: false,
    );
  }
}
