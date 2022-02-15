// import 'package:aba_analysis_local/components/search_delegate.dart';
// import 'package:aba_analysis_local/constants.dart';
// import 'package:aba_analysis_local/models/child.dart';
// import 'package:aba_analysis_local/models/test.dart';
// import 'package:aba_analysis_local/models/test_item.dart';
// import 'package:aba_analysis_local/provider/test_item_notifier.dart';
// import 'package:aba_analysis_local/screens/graph_management/date_graph_screen.dart';
// import 'package:aba_analysis_local/components/select_appbar.dart';
// import 'package:aba_analysis_local/components/build_list_tile.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import 'no_test_data_screen.dart';

// class SelectDateScreen extends StatefulWidget {
//   final Child child;
//   final List<Test> testList;
//   const SelectDateScreen(
//       {Key? key, required this.child, required this.testList})
//       : super(key: key);
//   static String routeName = '/select_date';

//   @override
//   _SelectDateScreenState createState() => _SelectDateScreenState();
// }

// class _SelectDateScreenState extends State<SelectDateScreen> {
//   late Map<String, List<Test>> testListAndDateMap = {};
//   String selectedDate = "";
//   // 검색 관련 변수

//   void initState() {
//     super.initState();

//     for (Test test in widget.testList) {
//       print(test.toString());
//     }

//     genTestListAndDateMap();
//   }

//   void genTestListAndDateMap() {
//     List<Test> testList = widget.testList;
//     // 테스트 리스트를 날짜별로 정렬
//     testList.sort((a, b) => a.date.compareTo(b.date));
//     for (Test t in testList) {
//       String nowDate = DateFormat(graphDateFormatNoTime).format(t.date);
//       // 만약 맵에 날짜가 없으면 날짜랑 같이 테스트리스트에 추가
//       if (!testListAndDateMap.containsKey(nowDate)) {
//         testListAndDateMap.addAll({
//           nowDate: [t]
//         });

//         // 만약 맵에 날짜가 있으면 해당 날짜의 테스트리스트에만 추가
//       } else {
//         testListAndDateMap[nowDate]!.add(t);
//       }
//     }
//   }

//   late String selectedText;

//   List<String> dateList = [];

//   @override
//   Widget build(BuildContext context) {
//     IconButton searchButton = IconButton(
//       // 검색버튼. 전역변수값을 변경해야되서 해당 스크린에서 정의했음.
//       icon: Icon(Icons.search),
//       onPressed: () async {
//         final finalResult = await showSearch(
//             context: context,
//             delegate: Search(testListAndDateMap.keys.toList()));
//         setState(() {
//           selectedDate = finalResult;
//         });
//       },
//     );
//     return GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: Scaffold(
//           appBar: selectAppBar(context, (widget.child.name + "의 테스트 날짜 선택"),
//               searchButton: searchButton),
//           body: testListAndDateMap.length == 0
//               ? noTestData()
//               : selectedDate == ""
//                   ? ListView.builder(
//                       // 검색된게 없으면
//                       padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
//                       itemCount: testListAndDateMap.keys.toList().length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return dataTile(testListAndDateMap.keys.toList()[index],
//                             index, context);
//                       },
//                     )
//                   : ListView.builder(
//                       // 검색된게 있다면
//                       padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
//                       itemCount: 1,
//                       itemBuilder: (BuildContext context, int index) {
//                         return dataTile(selectedDate, index, context);
//                       },
//                     ),
//         ));
//   }

//   Widget noTestData() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.auto_graph,
//             color: Colors.grey,
//             size: 150,
//           ),
//           Text(
//             'No Test Data',
//             style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 40,
//                 fontFamily: 'KoreanGothic'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget dataTile(String dateString, int index, BuildContext context) {
//     return buildListTile(
//       titleText: dateString,
//       onTap: () {
//         setState(() {
//           selectedDate = "";
//         });
//         bool notNull = true;
//         List<TestItem> testItemList = [];
//         for (Test test in testListAndDateMap[dateString]!) {
//           testItemList.addAll(context
//               .read<TestItemNotifier>()
//               .getTestItemList(test.testId, false));
//         }
//         for (TestItem ti in testItemList) {
//           print(ti.toString());
//           if (ti.p == 0 && ti.minus == 0 && ti.plus == 0) {
//             notNull = false;
//           }
//         }
//         if (notNull) {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => DateGraph(
//                         testList: testListAndDateMap[dateString]!,
//                         dateString: dateString,
//                         testItemList: testItemList,
//                       )));
//         } else {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => NoTestData()));
//         }
//       },
//       trailing: Icon(Icons.keyboard_arrow_right),
//     );
//   }
// }
