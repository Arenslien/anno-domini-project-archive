import 'package:aba_analysis_local/components/search_delegate.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:aba_analysis_local/screens/graph_management/item_graph_screen.dart';
import 'package:aba_analysis_local/components/select_appbar.dart';
import 'package:aba_analysis_local/screens/graph_management/no_test_data_screen.dart';
import 'package:aba_analysis_local/components/build_list_tile.dart';
import 'package:aba_analysis_local/services/db.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectItemScreen extends StatefulWidget {
  final Child child;
  final SubField subField;
  const SelectItemScreen({Key? key, required this.child, required this.subField}) : super(key: key);
  static String routeName = '/select_item';

  @override
  _SelectItemScreenState createState() => _SelectItemScreenState();
}

class _SelectItemScreenState extends State<SelectItemScreen> {
  late DBService db;

  // 전역변수
  late Map<String, TestItem> testItemAndsubItemNameMap = {};
  String selectedSubItem = "";
  bool isNoTestData = false;
  late List<Test> allTest;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0), () async {
      await db.initDatabase();
      allTest = await db.readTestList(widget.child.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    // for (Test test in allTest) {      // result가 null이라면
    //   for (TestItem testItem in test.testItemList) {
    //     if (testItem.result == null) {
    //       isNoTestData = true;
    //       break;
    //     }
    //   }
    // }

    IconButton searchButton = IconButton(
      // 검색버튼
      icon: Icon(Icons.search),
      onPressed: () async {
        final finalResult = await showSearch(context: context, delegate: Search(widget.subField.subItemList));
        setState(() {
          selectedSubItem = finalResult;
        });
      },
    );

    return Scaffold(
        appBar: selectAppBar(context, (widget.child.name + "의 하위목록 선택"), searchButton: searchButton),
        body: isNoTestData
            ? noTestData()
            : selectedSubItem == ""
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.subField.subItemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return dataTile(widget.subField.subItemList[index], index, context);
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return dataTile(selectedSubItem, index, context);
                    },
                  ));
  }

  Widget dataTile(String subItem, int index, BuildContext context) {
    return buildListTile(
      titleSize: 20,
      titleText: subItem,
      // subtitleText: "평균성공률: $average%",
      onTap: () async {
        List<SubItemAndDate> subItemList = [];
        // SubItemList 만들기
        // List<Test> allTest = context
        //     .read<TestNotifier>()
        //     .getAllTestListOf(widget.child.childId);

        List<TestItem> testItemNotNullList = await db.readAllTestItemNotNull();
        for (Test test in allTest) {
          List<TestItem> testItemList = [];
          for (TestItem testItem in testItemNotNullList) {
            if (test.id == testItem.testId) {
              testItemList.add(testItem);
            }
          }

          for (TestItem testItem in testItemList) {
            if (testItem.subItem == subItem && testItem.result != null) {
              subItemList.add(SubItemAndDate(testItem: testItem, date: test.date));
              break;
            }
          }
        }
        setState(() {
          selectedSubItem = "";
        });
        if (subItemList.isEmpty) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NoTestData()));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemGraphScreen(
                        subItemList: subItemList,
                        child: widget.child,
                      )));
        }
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  Widget noTestData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_graph,
            color: Colors.grey,
            size: 150,
          ),
          Text(
            'No Program Data',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 40, fontFamily: 'korean'),
          ),
        ],
      ),
    );
  }
}
