import 'package:flutter/material.dart';
import 'package:movie_app/features/movie/movie_repository.dart';
import 'package:movie_app/views/movie_views/movie_view_model.dart';
import 'package:provider/provider.dart';
import 'views/movie_views/movie_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final MovieRepository _repository;
  @override
  void initState() {
    super.initState();
    _repository = MovieRepository();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Provider<MovieViewModel>(
          create: (_) => MovieViewModel(_repository),
          builder: (_, __) {
            return const MovieView();
          }),
    );
  }
}
