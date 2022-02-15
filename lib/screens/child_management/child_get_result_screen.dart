import 'package:aba_analysis_local/provider/db_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:aba_analysis_local/components/build_list_tile.dart';
import 'package:aba_analysis_local/components/build_toggle_buttons.dart';

class ChildGetResultScreen extends StatefulWidget {
  final Child child;
  final Test test;
  final List<TestItem> testItem;
  const ChildGetResultScreen({Key? key, required this.child, required this.test, required this.testItem}) : super(key: key);

  @override
  _ChildGetResultScreenState createState() => _ChildGetResultScreenState();
}

class _ChildGetResultScreenState extends State<ChildGetResultScreen> {
  List<List<int>> countResult = [];

  bool flag = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.testItem.length; i++) {
      countResult.add([widget.testItem[i].plus, widget.testItem[i].minus, widget.testItem[i].p]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.child.name}의 ${widget.test.title}테스트',
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.check_rounded,
              color: Colors.black,
            ),
            onPressed: () async {
              if (!flag) {
                flag = true;
                // TestItem 생성
                List<TestItem> testItemList = widget.testItem;

                for (int i = 0; i < countResult.length; i++) {
                  // TestItem에 대한 각각의 p, + - 값 업데이트
                  TestItem testItem = testItemList[i];
                  testItem.setPlus(countResult[i][0]);
                  testItem.setMinus(countResult[i][1]);
                  testItem.setP(countResult[i][2]);

                  // DB 적용
                  // await store.updateTestItem(testItem);
                }
                // TestItem Provider에 적용
                // context.read<DBNotifier>().updateTestItemList(await store.readAllTestItem());

                // Test 업데이트
                // await store.updateTest(widget.test.testId, widget.test.date, widget.test.title, true);

                // Test Provider에 적용
                context.read<DBNotifier>().updateTest(widget.test.testId, widget.test.date, widget.test.title, true);

                Navigator.pop(context);
              }
            },
          ),
        ],
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount: widget.testItem.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              buildListTile(
                titleText: widget.testItem[index].subItem,
                trailing: buildToggleButtons(
                  text: ['+', '-', 'P'],
                  onPressed: (buttonIndex) {
                    setState(() {
                      if (buttonIndex == 0)
                        countResult[index][0]++;
                      else if (buttonIndex == 1)
                        countResult[index][1]++;
                      else if (buttonIndex == 2) countResult[index][2]++;
                    });
                  },
                  minWidth: 50,
                ),
                bottom: 0,
              ),
              buildListTile(
                titleText: '',
                trailing: buildToggleButtons(
                  text: [
                    '${countResult[index][0]}',
                    '${countResult[index][1]}',
                    '${countResult[index][2]}',
                  ],
                  minWidth: 50,
                ),
                top: 0,
              ),
            ],
          );
        },
      ),
    );
  }
}
