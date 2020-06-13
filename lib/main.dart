import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'details_page.dart';

void main() => runApp(new MaterialApp(
      home: new HomePage(),
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(Movie.fromJson(user));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Movie",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            Text(
              "Scrap",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
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
            getUserDetails();
          });
        },
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme
                .of(context)
                .primaryColor,
            child: new Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
              child: new Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                elevation: 3.0,
                child: new ListTile(
                  leading: new Icon(
                    Icons.search,
                    color: Colors.blue,
                  ),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 18.0),
                      border: InputBorder.none,
                    ),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: new IconButton(
                    icon: new Icon(
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
          Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
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
                      new BoxShadow(
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
              itemCount: _userDetails.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5.0,
                  child: ListTile(
                    title: Text(
                      _userDetails[index].name,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(_userDetails[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
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

    _userDetails.forEach((userDetail) {
      if (userDetail.normalized_name.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List<Movie> _searchResult = [];

List<Movie> _userDetails = [];

final String url = 'https://harishwarrior.github.io/JsonHosting/moviez.json';

class Movie {
  final String name;
  final String normalized_name;
  final List magnets;

  Movie({
    this.name,
    this.magnets,
    this.normalized_name,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return new Movie(
        name: json['name'],
        normalized_name: json['normalized_name'],
        magnets: json['magnets']);
  }
}
