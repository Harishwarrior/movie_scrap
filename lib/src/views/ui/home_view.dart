import 'package:flutter/material.dart';
import 'package:moviescrap/src/business_logic/fetch_data.dart';
import 'package:moviescrap/src/models/movie.dart';
import 'package:moviescrap/src/views/ui/settings_view.dart';

import 'details_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  bool completed;
  Future<List> movieList;
  List<Movie> _searchResult = [];
  FetchData fetchData = FetchData();

  //getMovieMetadata

  @override
  void initState() {
    movieList = fetchData.getMovieMetadata();
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
            fetchData.getMovieMetadata();
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
              future: movieList,
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
                            itemCount: fetchData.movieDetails.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5.0,
                                child: ListTile(
                                  title: Text(
                                    fetchData.movieDetails[index].name,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                            fetchData.movieDetails[index]),
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
    fetchData.movieDetails.forEach((_movieDetail) {
      if (_movieDetail.normalizedName.contains(text))
        _searchResult.add(_movieDetail);
    });
    setState(() {});
  }
}
