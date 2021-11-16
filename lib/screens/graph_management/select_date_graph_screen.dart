import 'package:aba_analysis_local/components/search_delegate.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:aba_analysis_local/screens/graph_management/date_graph_screen.dart';
import 'package:aba_analysis_local/components/select_appbar.dart';
import 'package:aba_analysis_local/services/db.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis_local/components/build_list_tile.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'no_test_data_screen.dart';

class SelectDateScreen extends StatefulWidget {
  final Child child;
  final List<Test> testList;
  const SelectDateScreen({Key? key, required this.child, required this.testList}) : super(key: key);
  static String routeName = '/select_date';

  @override
  _SelectDateScreenState createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  late DBService db;
  late Map<String, Test> testAndDateMap = {};
  String selectedDate = "";
  // 검색 관련 변수

  void initState() {
    super.initState();

    for (Test test in widget.testList) {
      print(test.toString());
    }

    Future.delayed(Duration(seconds: 0), () async {
      db = DBService(
        db: await openDatabase(
          join(await getDatabasesPath(), 'doggie_database.db'),
        ),
      );
    });
    genTestAndDateMap();
  }

  // Search관련해서 쓰일 Test와 Test날짜 Map을 만들어준다.
  void genTestAndDateMap() {
    for (Test t in widget.testList) {
      testAndDateMap.addAll({DateFormat(graphDateFormat).format(t.date).toString(): t});
    }
  }

  late String selectedText;

  List<String> dateList = [];

  @override
  Widget build(BuildContext context) {
    IconButton searchButton = IconButton(
      // 검색버튼. 전역변수값을 변경해야되서 해당 스크린에서 정의했음.
      icon: Icon(Icons.search),
      onPressed: () async {
        final finalResult = await showSearch(context: context, delegate: Search(testAndDateMap.keys.toList()));
        setState(() {
          selectedDate = finalResult;
        });
      },
    );
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: selectAppBar(context, (widget.child.name + "의 테스트 날짜 선택"), searchButton: searchButton),
          body: widget.testList.length == 0
              ? noTestData()
              : selectedDate == ""
                  ? ListView.builder(
                      // 검색된게 없으면
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
                      itemCount: widget.testList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(widget.testList[index], index, context);
                      },
                    )
                  : ListView.builder(
                      // 검색된게 있다면
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(testAndDateMap[selectedDate]!, index, context);
                      },
                    ),
        ));
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
            'No Test Data',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 40, fontFamily: 'KoreanGothic'),
          ),
        ],
      ),
    );
  }

  Widget dataTile(Test test, int index, BuildContext context) {
    return buildListTile(
      titleText: DateFormat(graphDateFormat).format(test.date),
      subtitleText: "평균성공률: ${getAvg(test)}%",
      onTap: () async {
        setState(() {
          selectedDate = "";
        });
        bool notNull = true;

        List<TestItem> testItemListNotNull = await db.readAllTestItemNotNull();

        List<TestItem> testItemList = [];
        for (TestItem testItem in testItemListNotNull) {
          if (testItem.testId == test.id) {
            testItemList.add(testItem);
          }
        }

        for (TestItem ti in testItemList) {
          if (ti.result == null) {
            notNull = false;
          }
        }
        if (notNull) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DateGraph(
                        test: test,
                      )));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NoTestData()));
        }
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  Future<int> getAvg(Test test) async {
    List<TestItem> testItemList = await db.readAllTestItemNotNull();
    int cnt = 0;
    int length = 0;

    for (TestItem testItem in testItemList) {
      if (testItem.testId == test.id) {
        length++;
        if (testItem.result == '+') cnt++;
      }
    }
    num average = (cnt / length * 100).toInt();

    return average.toInt();
  }
}
