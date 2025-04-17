import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/movies_provider.dart';
import '../widgets/movie_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isSearchFocused = false;
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
      if (_searchFocusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    _searchFocusNode.dispose();
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
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: FlexibleSpaceBar(
                title: Text(
                  'FluttyMovies',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark),
                color: theme.colorScheme.onPrimary,
                onPressed: () => context.push('/watchlist'),
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                color: theme.colorScheme.onPrimary,
                onPressed: () => context.push('/favorites'),
              ),
              IconButton(
                icon: const Icon(Icons.person),
                color: theme.colorScheme.onPrimary,
                onPressed: () => context.push('/profile'),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _isSearchFocused
                            ? theme.colorScheme.primary.withOpacity(0.3)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      letterSpacing: 0.5,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Rechercher un film...',
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        letterSpacing: 0.5,
                      ),
                      prefixIcon: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.search,
                          color: _isSearchFocused
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                          size: 24,
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                ref.read(popularMoviesProvider.notifier).loadMovies();
                              },
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            )
                          : null,
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    onSubmitted: (query) {
                      if (query.isNotEmpty) {
                        ref.read(popularMoviesProvider.notifier).searchMovies(query);
                      } else {
                        ref.read(popularMoviesProvider.notifier).loadMovies();
                      }
                    },
                    onChanged: (value) {
                      setState(() {});
                      if (value.isEmpty) {
                        ref.read(popularMoviesProvider.notifier).loadMovies();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: moviesState.when(
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Erreur: $error',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
              data: (movies) {
                if (movies.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Aucun film trouvé',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final movie = movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () => context.push('/movie/${movie.id}'),
                      );
                    },
                    childCount: movies.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 