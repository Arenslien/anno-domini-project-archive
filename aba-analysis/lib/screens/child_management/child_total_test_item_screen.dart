import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';

class ChildTotalTestItemScreen extends StatefulWidget {
  final Child child;
  final Map<String, List<int>> totalTestItemMap;
  const ChildTotalTestItemScreen({Key? key, required this.child, required this.totalTestItemMap}) : super(key: key);

  @override
  _ChildTotalTestItemScreenState createState() => _ChildTotalTestItemScreenState();
}

class _ChildTotalTestItemScreenState extends State<ChildTotalTestItemScreen> {
  _ChildTotalTestItemScreenState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.child.name}의 테스트 아이템 목록',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: mainGreenColor,
        ),
        body: ListView.builder(
          itemCount: widget.totalTestItemMap.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                buildListTile(
                  titleText: widget.totalTestItemMap.keys.toList()[index].toString(),
                  trailing: buildToggleButtons(
                    text: ['+', '-', 'P'],
                    minWidth: 50,
                  ),
                  bottom: 0,
                ),
                buildListTile(
                  titleText: '테스트 횟수: ${widget.totalTestItemMap.values.toList()[index][3]}',
                  titleSize: 15,
                  trailing: buildToggleButtons(
                    text: [
                      '${widget.totalTestItemMap.values.toList()[index][0]}',
                      '${widget.totalTestItemMap.values.toList()[index][1]}',
                      '${widget.totalTestItemMap.values.toList()[index][2]}',
                    ],
                    minWidth: 50,
                  ),
                  top: 0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
