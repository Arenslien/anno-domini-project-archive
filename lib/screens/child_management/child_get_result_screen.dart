import 'package:aba_analysis_local/provider/db_notifier.dart';
import 'package:aba_analysis_local/services/db.dart';
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

  String? memo;

  bool flag = false;
  String memo = "";

  DBService db = DBService();

  TextEditingController memoTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //print testItem
    for (TestItem ti in widget.testItem) {
      print("puls: ${ti.plus} minus: ${ti.minus} p: ${ti.p}");
    }

    for (int i = 0; i < widget.testItem.length; i++) {
      countResult.add([widget.testItem[i].plus, widget.testItem[i].minus, widget.testItem[i].p]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                  for (int i = 0; i < countResult.length; i++) {
                    if (countResult[i][0] + countResult[i][1] + countResult[i][2] == 0) {
                      flag = false;
                      ScaffoldMessenger.of(context).showSnackBar(makeSnackBar('입력되지 않은 테스트가 존재합니다.', false));
                      return;
                    }
                  }

                  Test updatedTest = widget.test;
                  updatedTest.isInput = true;

                  // TestItem 생성
                  List<TestItem> testItemList = widget.testItem;

                  for (int i = 0; i < countResult.length; i++) {
                    // TestItem에 대한 각각의 p, + - 값 업데이트
                    TestItem testItem = testItemList[i];
                    testItem.setPlus(countResult[i][0]);
                    testItem.setMinus(countResult[i][1]);
                    testItem.setP(countResult[i][2]);

                    // DB 적용
                    await db.updateTestItem(testItem.testItemId, testItem.plus, testItem.minus, testItem.p);
                  }

                  // Test 적용
                  await db.updateTest(updatedTest);

                  // TestItem Provider에 적용
                  await context.read<DBNotifier>().updateTestItemList();
                  await context.read<DBNotifier>().updateTestList();

                  Navigator.pop(context);
                }
              },
            ),
          ],
          backgroundColor: mainGreenColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 500,
                child: ListView.builder(
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: memoTextEditingController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '메모',
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  cursorColor: Colors.black,
                  onChanged: (value) {
                    setState(() {
                      memo = memoTextEditingController.text;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
