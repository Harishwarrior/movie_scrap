import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/movie.dart';

class DetailPage extends StatelessWidget {
  final Movie movie;

  DetailPage(this.movie);

  String fileSize(String url) {
    RegExp exp = new RegExp(r"[0-9]+(\.[0-9])?(GB|MB|gb|mb)");
    String match = exp.stringMatch(Uri.decodeComponent(url));
    if (match == null) {
      return 'Unknown Size';
    } else {
      return match;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    var commentWidgets = List<Widget>();
    for (String magnet in movie.magnets) {
      commentWidgets.add(
        OutlineButton(
          highlightColor: Colors.blue,
          child: Text(
            fileSize(magnet),
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 18.0),
          ),
          color: Colors.pinkAccent,
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: magnet));
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: const Text('Magnet link copied to clipboard'),
              duration: Duration(seconds: 3),
            ));
          },
          onPressed: () async {
            var url = magnet;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          }, //onPressed
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
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
