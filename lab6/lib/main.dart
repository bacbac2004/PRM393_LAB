import 'package:flutter/material.dart';

void main() => runApp(const ResponsiveMovieApp());

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

const List<Movie> allMovies = [
  Movie(title: 'Dune: Part Two', year: 2024, genres: ['Sci-Fi', 'Adventure', 'Drama'],
      posterUrl: 'https://image.tmdb.org/t/p/w500/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg', rating: 8.6),
  Movie(title: 'Deadpool & Wolverine', year: 2024, genres: ['Action', 'Comedy'],
      posterUrl: 'https://image.tmdb.org/t/p/w500/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg', rating: 8.3),
  Movie(title: 'Inside Out 2', year: 2024, genres: ['Animation', 'Comedy', 'Drama'],
      posterUrl: 'https://image.tmdb.org/t/p/w500/vpnVM9B6NMmQpWeZvzLvDESb2QY.jpg', rating: 8.0),
  Movie(title: 'The Batman', year: 2022, genres: ['Action', 'Drama'],
      posterUrl: 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg', rating: 7.8),
  Movie(title: 'Spider-Man: No Way Home', year: 2021, genres: ['Action', 'Adventure', 'Sci-Fi'],
      posterUrl: 'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg', rating: 8.2),
  Movie(title: 'The Dark Knight', year: 2008, genres: ['Action', 'Drama'],
      posterUrl: 'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg', rating: 9.0),
];

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Browser',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFFAF8FF),
      ),
      home: const GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = '';
  final List<String> genres = ['Action', 'Adventure', 'Comedy', 'Drama', 'Sci-Fi', 'Animation'];
  final Set<String> selectedGenres = {};
  String selectedSort = 'A-Z';

  List<Movie> get visibleMovies {
    final result = allMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesGenre = selectedGenres.isEmpty ||
          movie.genres.any((genre) => selectedGenres.contains(genre));
      return matchesSearch && matchesGenre;
    }).toList();

    switch (selectedSort) {
      case 'A-Z':
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        result.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Year':
        result.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'Rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return result;
  }

  void clearFilters() {
    setState(() {
      searchQuery = '';
      selectedGenres.clear();
      selectedSort = 'A-Z';
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isLandscape = media.orientation == Orientation.landscape;
    final horizontalPadding = media.size.width >= 800 ? 28.0 : 16.0;
    final compact = isLandscape && media.size.height < 500;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 800;
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    compact ? 8 : 16,
                    horizontalPadding,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find a Movie',
                          style: TextStyle(
                            fontSize: compact ? 23 : 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: compact ? 8 : 16),
                        TextField(
                          onChanged: (value) => setState(() => searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Search movies...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => setState(() => searchQuery = ''),
                            )
                                : null,
                            filled: true,
                            fillColor: Colors.white,
                            isDense: compact,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: compact ? 10 : 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: compact ? 8 : 16),
                        Row(
                          children: [
                            Text(
                              'Genres',
                              style: TextStyle(
                                fontSize: compact ? 15 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (selectedGenres.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${selectedGenres.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: compact ? 4 : 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: compact ? 2 : 6,
                          children: genres.map((genre) {
                            return FilterChip(
                              label: Text(genre),
                              selected: selectedGenres.contains(genre),
                              visualDensity: compact
                                  ? VisualDensity.compact
                                  : VisualDensity.standard,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onSelected: (value) {
                                setState(() {
                                  if (value) {
                                    selectedGenres.add(genre);
                                  } else {
                                    selectedGenres.remove(genre);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: compact ? 2 : 8),
                        Row(
                          children: [
                            const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: selectedSort,
                              isDense: compact,
                              items: const [
                                DropdownMenuItem(value: 'A-Z', child: Text('A-Z')),
                                DropdownMenuItem(value: 'Z-A', child: Text('Z-A')),
                                DropdownMenuItem(value: 'Year', child: Text('Year')),
                                DropdownMenuItem(value: 'Rating', child: Text('Rating')),
                              ],
                              onChanged: (value) {
                                if (value != null) setState(() => selectedSort = value);
                              },
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: clearFilters,
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                        Text(
                          '${visibleMovies.length} movies found',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                        ),
                        SizedBox(height: compact ? 4 : 10),
                      ],
                    ),
                  ),
                ),
                if (visibleMovies.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No movies found')),
                  )
                else if (isWide)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 8,
                        mainAxisExtent: compact ? 145 : 175,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => MovieCard(
                          movie: visibleMovies[index],
                          compact: compact,
                        ),
                        childCount: visibleMovies.length,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => MovieCard(
                          movie: visibleMovies[index],
                          compact: compact,
                        ),
                        childCount: visibleMovies.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool compact;

  const MovieCard({
    super.key,
    required this.movie,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final posterWidth = compact ? 76.0 : 100.0;
    final posterHeight = compact ? 112.0 : 140.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.all(compact ? 7 : 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                movie.posterUrl,
                width: posterWidth,
                height: posterHeight,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: posterWidth,
                  height: posterHeight,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.movie, size: 36),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 15 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${movie.year}  •  ⭐ ${movie.rating.toStringAsFixed(1)}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: compact ? 12 : 14),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 0,
                    children: movie.genres.take(2).map((genre) {
                      return Chip(
                        label: Text(genre, style: TextStyle(fontSize: compact ? 9 : 10)),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
