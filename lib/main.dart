import 'package:flutter/material.dart';
import 'package:moviescrap/Services/fetch_json.dart';

import 'details_page.dart';

Fetch fetch = new Fetch();
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
  Fetch fetch = new Fetch();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MovieSearch());
            },
          ),
        ],
      ),
    );
  }
}

class MovieSearch extends SearchDelegate {
  final suggestMovie = ["avenger", "ant-man"];

  @override
  List<Widget> buildActions(BuildContext context) {
    // implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: fetch.getMovies(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(child: Center(child: Text("Loading...")));
          } else {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 5.0,
                  child: ListTile(
                    title: Text(
                      snapshot.data[index].normalized_name,
                    ),
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
    );
  }
}
