import 'package:flutter/material.dart';
import 'package:show_me_the_graph/screens/graph_screen.dart';
import 'package:show_me_the_graph/source/data_source.dart';


class DataCard extends StatefulWidget {
  final GraphData data;

  DataCard(this.data);

  @override
  _DataCardState createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            widget.data.getTitle(),
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text("image1"), Text("image2")],
          ),
          SizedBox(height: 10),
          Text(
            widget.data.getPercentage().toString(),
            style: TextStyle(fontSize: 20),
          ),
          TextButton(
            child: Text("Graph"),
            onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => GraphScreen(data: widget.data))
              );
            },
          )
        ],
      ),
      margin: EdgeInsets.all(30)
    );
  }
}

class NoDataCard extends StatefulWidget {
  @override
  _NoDataCardState createState() => _NoDataCardState();
}

class _NoDataCardState extends State<NoDataCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "아직 데이터가 없습니다. 추가해주세요.",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
      margin: EdgeInsets.all(30),
    );
  }
}