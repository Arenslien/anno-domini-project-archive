import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';

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

  late TextEditingController memoTextEditingController;

  bool flag = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.testItem.length; i++) {
      countResult.add([widget.testItem[i].plus, widget.testItem[i].minus, widget.testItem[i].p]);
    }
    memoTextEditingController = TextEditingController(text: widget.test.memo);
  }

  @override
  Widget build(BuildContext context) {
    FireStoreService store = FireStoreService();
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
                  // TestItem 생성
                  List<TestItem> testItemList = widget.testItem;

                  for (int i = 0; i < countResult.length; i++) {
                    // TestItem에 대한 각각의 p, + - 값 업데이트
                    TestItem testItem = testItemList[i];
                    testItem.setPlus(countResult[i][0]);
                    testItem.setMinus(countResult[i][1]);
                    testItem.setP(countResult[i][2]);

                    // DB 적용
                    await store.updateTestItem(testItem);
                  }
                  // TestItem Provider에 적용
                  context.read<TestItemNotifier>().updateTestItemList(await store.readAllTestItem());

                  // Test 업데이트
                  await store.updateTest(widget.test.testId, widget.test.date, widget.test.title, true, memoTextEditingController.text);

                  // Test Provider에 적용
                  context.read<TestNotifier>().updateTestList(await store.readAllTest());

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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
