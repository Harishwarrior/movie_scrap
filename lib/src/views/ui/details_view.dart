import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/movie.dart';

class DetailPage extends StatelessWidget {
  final Movie movie;

  DetailPage(this.movie);

  String fileSize(String url) {
    final exp = RegExp(r'[0-9]+(\.[0-9])?(GB|MB|gb|mb)');
    var match = exp.stringMatch(Uri.decodeComponent(url));
    if (match == null) {
      return 'Unknown Size';
    } else {
      return match;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final commentWidgets = <Widget>[];
    for (var magnet in movie.magnets as Iterable<String>) {
      commentWidgets.add(
        OutlinedButton(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: magnet));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
          },
          child: Text(
            fileSize(magnet),
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 18.0),
          ), //onPressed
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
                  movie.name!,
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
