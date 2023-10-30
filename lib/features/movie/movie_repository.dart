import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/features/movie/movie_model.dart';
import 'package:movie_app/helpers/helper.dart';

class MovieRepository {
  Future<List<int>> getMovieIds() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=$apiKey'),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiN2Q3NDE5NWVlMDExYzI0MzFkNyIsInN1YiI6IjY1MzhlMjNmZjQ5NWVlMDExYzI0MzFkNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.VdHAc3P1YOtMWCf0tqFzDLdXGaYIiU-6LoRSdUe3pPI'
      },
    );
    List<int> ids = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> results = data['results'];

      for (var item in results) {
        int id = item['id'];
        ids.add(id);
      }
    }

    return ids;
  }

  Future<MovieModel> getMovieDetails(int id) async {
    final response = await http
        .get(Uri.parse('https://api.themoviedb.org/3/movie/$id'), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiN2Q3NDE1Y2UyOWE4ZDJiYTAzOTVmN2Y5MTRhNDEyMCIsInN1YiI6IjY1MzhlMjNmZjQ5NWVlMDExYzI0MzFkNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.VdHAc3P1YOtMWCf0tqFzDLdXGaYIiU-6LoRSdUe3pPI'
    });
    return MovieModel.fromMap(jsonDecode(response.body));
  }
}
