import 'package:flutter/material.dart';
import 'package:movie_app/features/movie/movie_model.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieModel movieModel;
  const MovieDetailsScreen({super.key, required this.movieModel});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back_ios,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(60),
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.network(
                    "https://image.tmdb.org/t/p/original${widget.movieModel.posterPath}"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.movieModel.title,
              style:
                  const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            child: Text(
              widget.movieModel.overview,
              // maxLines: ,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.check,
                size: 25.0,
              ),
              Icon(
                Icons.share,
                size: 25.0,
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('My List'),
                Text('Share'),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
