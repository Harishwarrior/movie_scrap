import 'package:flutter/material.dart';
import 'package:moviescrap/src/utils/media_query.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey[300],
              child: ShimmerLayout(),
              period: Duration(milliseconds: time),
            ),
          );
        },
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                height: displayHeight(context) * 0.02,
                width: displayWidth(context) * 0.92,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Container(
                height: displayHeight(context) * 0.02,
                width: displayWidth(context) * 0.75,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
            ],
          )
        ],
      ),
    );
  }
}
