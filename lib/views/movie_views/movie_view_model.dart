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

  MovieViewModel(this._movieRepository);

  Future<void> loadMovieData() async {
    _movieNotifier.value = MovieLoading();
    try {
      final movieIds = await _movieRepository.getMovieIds();
      List<MovieModel> movies = [];
      if (movieIds.isNotEmpty) {
        for (int i = 0; i < movieIds.length; i++) {
          final movieId = movieIds[i];
          final movieDetails = await _movieRepository.getMovieDetails(movieId);
          movies.add(movieDetails);
        }
        _movieNotifier.value = MovieLoaded(movie: movies);
      } else {
        _movieNotifier.value =
            const MovieError(error: "No movie IDs available.");
      }
    } catch (e) {
      _movieNotifier.value = MovieError(error: e.toString());
    }
  }
}
