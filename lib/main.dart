import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movie.dart';
import 'details_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Movie DB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Movie>> _getMovies() async {
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getMovies(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("Loading...")));
            } else {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 10.0,
                    child: ListTile(
                      title: Text(snapshot.data[index].normalized_name),
//                    subtitle: Text(snapshot.data[index].magnets),
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(snapshot.data[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
