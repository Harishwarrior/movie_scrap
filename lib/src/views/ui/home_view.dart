import 'package:flutter/material.dart';
import 'package:moviescrap/src/business_logic/fetch_data.dart';
import 'package:moviescrap/src/models/movie.dart';
import 'package:moviescrap/src/views/ui/settings_view.dart';
import 'package:moviescrap/src/views/widgets/shimmer_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'details_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  bool? completed;
  Future<List>? movieList;
  final List<Movie> _searchResult = [];
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
              'Movie',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Scrap',
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
        onPressed: () {
          setState(() {
            fetchData.getMovieMetadata();
          });
        },
        child: Icon(
          Icons.refresh,
        ),
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
                  if (kIsWeb) {
                    return Center(
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                    // running on the web!
                  } else {
                    // NOT running on the web! You can check for additional platforms here.
                    return ShimmerList();
                  }
                } else {
                  return Expanded(
                    child: _searchResult.isNotEmpty ||
                            controller.text.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResult.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.lightBlue,
                                      blurRadius: 0.1,
                                      offset: Offset(0.0, 0.5),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  elevation: 5.0,
                                  child: ListTile(
                                    title: Text(
                                      _searchResult[index].name!,
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
                                    fetchData.movieDetails[index].name!,
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

  Future<void> onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
    }
    fetchData.movieDetails.forEach((_movieDetail) {
      if (_movieDetail.normalizedName!.contains(text)) {
        _searchResult.add(_movieDetail);
      }
    });
    setState(() {});
  }
}
