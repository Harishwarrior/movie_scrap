import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moviescrap/src/utils/media_query.dart';

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 70.0,
          ),
          Card(
            margin: EdgeInsets.all(20.0),
            child: Container(
              margin: EdgeInsets.all(15.0),
              height: displayHeight(context) * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'About App',
                    style: TextStyle(fontSize: 25.0),
                  ),
                  Text(
                    'An quarantine project, created with the help of Nandha',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.black,
                  ),
                  Text(
                    'About Dev',
                    style: TextStyle(fontSize: 25.0),
                  ),
                  Text(
                    'Student | Flutter Dev | Android dev',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.black,
                  ),
                  Text(
                    'Contact',
                    style: TextStyle(fontSize: 25.0),
                  ),
                ],
              ),
            ),
          ),
          Text('Made with Flutter ♥ in India'),
          SizedBox(
            height: 15.0,
          )
        ],
      ),
    );
  }
}
