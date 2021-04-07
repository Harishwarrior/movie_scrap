import 'dart:convert';
import 'package:moviescrap/src/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:moviescrap/src/utils/constants.dart';

class FetchData {
  List<Movie> movieDetails = [];

  Future<List> getMovieMetadata() async {
    final response = await http.get(Uri.parse(url));
    final responseJson = json.decode(response.body);

    for (Map movie in responseJson) {
      movieDetails.add(Movie.fromJson(movie));
    }

    return movieDetails;
  }
}
