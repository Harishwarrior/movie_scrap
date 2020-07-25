import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moviescrap/theme.dart';
import 'package:moviescrap/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'details_page.dart';
import 'movie.dart';
import 'settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (context) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'MovieScrap',
      theme: themeNotifier.getTheme(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  bool completed;

  final String url = 'https://harishwarrior.github.io/JsonHosting/moviez.json';

  Future<List> getMovieMetadata() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    for (Map movie in responseJson) {
      _movieDetails.add(Movie.fromJson(movie));
    }

    return _movieDetails;
  } //getMovieMetadata

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Movie",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              "Scrap",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (SettingsPage())),
                );
              }),
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.refresh,
        ),
        onPressed: () {
          setState(() {
            getMovieMetadata();
          });
        },
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                elevation: 3.0,
                child: ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.blue,
                  ),
                  title: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 18.0),
                      border: InputBorder.none,
                    ),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },
                  ),
                ),
              ),
            ),
          ),
          FutureBuilder(
              future: getMovieMetadata(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  );
                } else {
                  return Expanded(
                    child: _searchResult.length != 0 ||
                            controller.text.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResult.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Card(
                                  elevation: 5.0,
                                  child: ListTile(
                                    title: Text(
                                      _searchResult[index].name,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPage(_searchResult[index]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.lightBlue,
                                      blurRadius: 0.1,
                                      offset: Offset(0.0, 0.5),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: _movieDetails.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5.0,
                                child: ListTile(
                                  title: Text(
                                    _movieDetails[index].name,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(_movieDetails[index]),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  );
                }
              }),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _movieDetails.forEach((movieDetail) {
      if (movieDetail.normalizedName.contains(text))
        _searchResult.add(movieDetail);
    });
    setState(() {});
  }
}

List<Movie> _searchResult = [];

List<Movie> _movieDetails = [];
