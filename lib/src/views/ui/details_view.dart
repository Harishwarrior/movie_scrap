import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviescrap/src/business_logic/get_file_size.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/movie.dart';

class DetailPage extends StatelessWidget {
  final Movie movie;
  DetailPage(this.movie);

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final commentWidgets = <Widget>[];
    for (var magnet in movie.magnets as List<dynamic>) {
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
