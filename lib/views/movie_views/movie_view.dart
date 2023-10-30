import 'package:flutter/material.dart';
import 'package:movie_app/views/movie_views/movie_details_screen.dart';
import 'package:movie_app/views/movie_views/movie_view_model.dart';
import 'package:provider/provider.dart';

class MovieView extends StatefulWidget {
  const MovieView({super.key});

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  late final MovieViewModel mvm;
  @override
  void initState() {
    super.initState();
    mvm = context.read<MovieViewModel>();
    mvm.loadMovieData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        backgroundColor: Colors.pink,
        title: const Text(
          'MOVIES',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 35, color: Colors.black),
        ),
        actions: const [
          Icon(
            Icons.search_outlined,
            size: 30,
            color: Colors.black,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: mvm.movieNotifier,
        builder: (_, movieState, __) {
          if (movieState is MovieIntial || movieState is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (movieState is MovieError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              const snackBar = SnackBar(
                content: Text(
                  'Error',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.redAccent,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });

            return Text('An Error Occured : ${movieState.error}');
          }

          final movies = (movieState as MovieLoaded).movie;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        movie.originalTitle,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsScreen(
                                movieModel: movies[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                              left: 75, right: 75, top: 10, bottom: 50),
                          child: Image.network(
                            "https://image.tmdb.org/t/p/original${movie.posterPath}",
                          ),
                        ),
                      ),
                    ]),
              );
            },
          );
        },
      ),
    );
  }
}
