import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/services/db.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:aba_analysis_local/components/build_list_tile.dart';
import 'package:aba_analysis_local/components/build_toggle_buttons.dart';

class ChildGetResultScreen extends StatefulWidget {
  final Child child;
  final Test test;
  const ChildGetResultScreen({Key? key, required this.child, required this.test}) : super(key: key);

  @override
  _ChildGetResultScreenState createState() => _ChildGetResultScreenState();
}

class _ChildGetResultScreenState extends State<ChildGetResultScreen> {
  late DBService db;

  late List<TestItem> testItem;

  List<String?> result = [];
  List<List<bool>> resultSelected = [];
  List<List<int>> countResult = [];

  bool checkResultList() {
    // 참일 때 문제 없음
    bool returnValue = true;
    for (int i = 0; i < result.length; i++) if (result[i] == null) return false;
    return returnValue;
  }

  @override
  Future<void> initState() async {
    super.initState();

    Future.delayed(Duration(seconds: 0), () async {
      await db.initDatabase();
      testItem = (await db.readTestItemList(widget.test.id!));
    });

    for (int i = 0; i < testItem.length; i++) {
      countResult.add([0, 0, 0]);
      for (TestItem temp in await db.readTestItemListByChild(widget.child.id!)) {
        // 테스트 진행중인 테스트 아이템은 무시한다
        if (temp.testId == testItem[i].testId) continue;
        if (temp.subItem == testItem[i].subItem) {
          if (temp.result == '+') {
            countResult[countResult.length - 1][0]++;
          } else if (temp.result == '-') {
            countResult[countResult.length - 1][1]++;
          } else if (temp.result == 'P') {
            countResult[countResult.length - 1][2]++;
          }
        }
      }

      if (testItem[i].result == null) {
        result.add(null);
        resultSelected.add([false, false, false]);
        continue;
      } else if (testItem[i].result == '+') {
        result.add('+');
        resultSelected.add([true, false, false]);
      } else if (testItem[i].result == '-') {
        result.add('-');
        resultSelected.add([false, true, false]);
      } else if (testItem[i].result == 'P') {
        result.add('P');
        resultSelected.add([false, false, true]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // FireStoreService store = FireStoreService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.child.name} : ${widget.test.title}',
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
              if (checkResultList()) {
                for (int i = 0; i < testItem.length; i++) {
                  db.updateTestItem(testItem[i].id!, result[i]!);
                }
                db.updateTest(widget.test);

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(makeSnackBar('테스트 아이템 결과값을 다 체크해주세요.', false));
              }
            },
          ),
        ],
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount: testItem.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              buildListTile(
                titleText: testItem[index].subItem,
                trailing: buildToggleButtons(
                  text: ['+', '-', 'P'],
                  onPressed: (buttonIndex) {
                    if (buttonIndex == 0)
                      result[index] = '+';
                    else if (buttonIndex == 1)
                      result[index] = '-';
                    else if (buttonIndex == 2) result[index] = 'P';

                    setState(() {
                      for (int i = 0; i < 3; i++) {
                        resultSelected[index][i] = false;
                        if (buttonIndex == i) {
                          resultSelected[index][i] = true;
                        }
                      }
                    });
                  },
                  isSelected: resultSelected[index],
                  minWidth: 50,
                ),
                bottom: 0,
              ),
              buildListTile(
                titleText: '',
                trailing: buildToggleButtons(
                  text: [
                    '${countResult[index][0] + (resultSelected[index][0] ? 1 : 0)}',
                    '${countResult[index][1] + (resultSelected[index][1] ? 1 : 0)}',
                    '${countResult[index][2] + (resultSelected[index][2] ? 1 : 0)}',
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
