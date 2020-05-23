import 'package:flutter/material.dart';
import 'movie.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final Movie movie;
  DetailPage(this.movie);

  @override
  Widget build(BuildContext context) {
    var commentWidgets = List<Widget>();
    for (String magnet in movie.magnets) {
      commentWidgets.add(
        RaisedButton(
          child: Text(
            "link ",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18.0),
          ),
          color: Colors.pinkAccent,
          onPressed: () async {
            var url = magnet;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  movie.name,
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
              child: Column(
                children: commentWidgets,
              ),
            )
          ],
        ),
      ),
    );
  }
}
