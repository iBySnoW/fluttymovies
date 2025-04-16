import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/movies_provider.dart';
import '../widgets/movie_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(popularMoviesProvider.notifier).loadMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final moviesState = ref.watch(popularMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FluttyMovies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un film...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  ref.read(popularMoviesProvider.notifier).searchMovies(query);
                }
              },
            ),
          ),
          Expanded(
            child: moviesState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Erreur: $error')),
              data: (movies) {
                if (movies.isEmpty) {
                  return const Center(child: Text('Aucun film trouvé'));
                }

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () => context.push('/movie/${movie.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 