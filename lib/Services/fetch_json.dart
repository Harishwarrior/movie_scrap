import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moviescrap/movie.dart';

class Fetch {
  Future<List<Movie>> getMovies() async {
    var data = await http
        .get("https://harishwarrior.github.io/JsonHosting/movie.json");
    var jsonData = json.decode(data.body);

    List<Movie> movies = [];

    for (var u in jsonData) {
      Movie movie = Movie(
          name: u["name"],
          magnets: u["magnets"],
          normalized_name: u["normalized_name"]);
      movies.add(movie);
    }

    return movies;
  }
}
