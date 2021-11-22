import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:aba_analysis_local/provider/db_notifier.dart';
import 'package:aba_analysis_local/components/build_list_tile.dart';
import 'package:aba_analysis_local/components/build_toggle_buttons.dart';

class ChildGetResultScreen extends StatefulWidget {
  const ChildGetResultScreen({Key? key, required this.child, required this.test}) : super(key: key);
  final Child child;
  final Test test;

  @override
  _ChildGetResultScreenState createState() => _ChildGetResultScreenState();
}

class _ChildGetResultScreenState extends State<ChildGetResultScreen> {
  late List<TestItem> testItemList;

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
  void initState() {
    super.initState();

    testItemList = context.read<DBNotifier>().getTestItemList(widget.test.id!, true);

    // 아이가 갖고 있는 모든 테스트의 동일 아이템 결과값 카운트
    for (int i = 0; i < testItemList.length; i++) {
      countResult.add([0, 0, 0]);
      // 아이가 가진 모든 테스트 아이템을 가져옴
      for (TestItem temp in context.read<DBNotifier>().getTestItemListFromChildId(widget.child.id!, true)) {
        // 테스트 진행중인 테스트 아이템은 무시한다
        if (temp.testId == testItemList[i].testId) continue;
        // 카운팅할 하위목록과 일치하면 결과값에 따라 카운트 증가
        if (temp.subItem == testItemList[i].subItem) {
          if (temp.result == '+') {
            countResult[countResult.length - 1][0]++;
          } else if (temp.result == '-') {
            countResult[countResult.length - 1][1]++;
          } else if (temp.result == 'P') {
            countResult[countResult.length - 1][2]++;
          }
        }
      }

      // 현재 테스트의 결과값 상태 표시
      if (testItemList[i].result == '+') {
        result.add('+');
        resultSelected.add([true, false, false]);
      } else if (testItemList[i].result == '-') {
        result.add('-');
        resultSelected.add([false, true, false]);
      } else if (testItemList[i].result == 'P') {
        result.add('P');
        resultSelected.add([false, false, true]);
      } else {
        result.add(null);
        resultSelected.add([false, false, false]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                for (int i = 0; i < testItemList.length; i++) {
                  await context.read<DBNotifier>().database!.updateTestItem(testItemList[i].id!, result[i]!);
                  context.read<DBNotifier>().updateTestItem(testItemList[i].id!, result[i]!);
                }
                await context.read<DBNotifier>().database!.updateTest(widget.test);
                context.read<DBNotifier>().updateTest(widget.test.id!, widget.test.date, widget.test.title, true);

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
        itemCount: testItemList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              buildListTile(
                titleText: testItemList[index].subItem,
                trailing: buildToggleButtons(
                  text: ['+', '-', 'P'],
                  onPressed: (buttonIndex) {
                    // + 누르면
                    if (buttonIndex == 0)
                      result[index] = '+';
                    // - 누르면
                    else if (buttonIndex == 1)
                      result[index] = '-';
                    // P 누르면
                    else if (buttonIndex == 2) result[index] = 'P';

                    // 기존 누른값 초기화 후 현재 누른값만 표시
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
