import 'package:flutter/foundation.dart';
import 'package:movie_app/features/movie/movie_model.dart';
import 'package:movie_app/features/movie/movie_repository.dart';

abstract class MovieState {}

class MovieIntial implements MovieState {}

class MovieLoading implements MovieState {}

class MovieError implements MovieState {
  final String error;
  const MovieError({required this.error});
}

class MovieLoaded implements MovieState {
  final List<MovieModel> movie;
  MovieLoaded({required this.movie});
}

class MovieViewModel {
  final MovieRepository _movieRepository;
  final ValueNotifier<MovieState> _movieNotifier = ValueNotifier(MovieIntial());
  ValueListenable<MovieState> get movieNotifier => _movieNotifier;
  List<MovieModel> _movies = [];
  String _cQuery = "";

  MovieViewModel(this._movieRepository);

  Future<void> loadMovieData() async {
    _movieNotifier.value = MovieLoading();
    try {
      final movieIds = await _movieRepository.getMovieIds();
      List<Future<MovieModel>> moviesFutures = [];
      if (movieIds.isNotEmpty) {
        for (int i = 0; i < movieIds.length; i++) {
          final movieId = movieIds[i];
          moviesFutures.add(_movieRepository.getMovieDetails(movieId));
        }
        _movies = await Future.wait(moviesFutures);
        _movieNotifier.value = MovieLoaded(movie: _movies);
      } else {
        _movieNotifier.value =
            const MovieError(error: "No movie IDs available.");
      }
    } catch (e) {
      _movieNotifier.value = MovieError(error: e.toString());
      rethrow;
    }
  }

  bool isSubString(String first, String second) {
    if (first.length < second.length) {
      return false;
    }
    if (second == first.substring(0, second.length)) {
      return true;
    }
    return false;
  }

  void search(String query) {
    if (_movieNotifier.value is MovieLoaded) {
      if (query.isEmpty) {
        _movieNotifier.value = MovieLoaded(movie: _movies);
        return;
      }
      var foo = query.toLowerCase();
      if (foo == _cQuery) {
        return;
      }
      if (isSubString(_cQuery, foo)) {
        _cQuery = foo;
        return;
      }
      _cQuery = foo;
      final List<MovieModel> movies = _movies;
      // .where((element) => element.title.toLowerCase().contains(foo))
      // .toList();
      final List<MovieModel> searchedMovies = [];
      for (var i = 0; i < movies.length; i++) {
        final MovieModel movie = movies[i];
        final querylength = foo.length;
        final titleLength = movie.title.length;
        if (querylength > titleLength) {
          continue;
        }
        final clippedTitle = movie.title.substring(0, querylength);
        if (clippedTitle.toLowerCase() == foo) {
          searchedMovies.add(movie);
        }
      }
      _movieNotifier.value = MovieLoaded(movie: searchedMovies);
    }
  }
}
