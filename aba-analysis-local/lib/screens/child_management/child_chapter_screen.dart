// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:aba_analysis_local/constants.dart';
// import 'package:aba_analysis_local/models/test.dart';
// import 'package:aba_analysis_local/models/child.dart';
// import 'package:aba_analysis_local/provider/test_notifier.dart';
// import 'package:aba_analysis_local/components/build_list_tile.dart';
// import 'package:aba_analysis_local/components/build_no_list_widget.dart';
// import 'package:aba_analysis_local/components/build_toggle_buttons.dart';
// import 'package:aba_analysis_local/components/build_text_form_field.dart';
// import 'package:aba_analysis_local/screens/test_management/test_input_screen.dart';

// class ChildChapterScreen extends StatefulWidget {
//   const ChildChapterScreen({required this.child, Key? key}) : super(key: key);
//   final Child child;

//   @override
//   _ChildChapterScreenState createState() => _ChildChapterScreenState();
// }

// class _ChildChapterScreenState extends State<ChildChapterScreen> {
//   _ChildChapterScreenState();
//   List<Test> testList = [];
//   List<Test> searchResult = [];
//   List<Widget> testCardList = [];
//   List<Widget> searchTestCardList = [];
//   TextEditingController searchTextEditingController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       setState(() {
//         testList = context.read<TestNotifier>().getAllTestListOf(widget.child.childId, true);
//       });
//     });

//     testCardList = convertChildToListTile(testList);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             widget.child.name,
//             style: TextStyle(color: Colors.black),
//           ),
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back_rounded,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           backgroundColor: mainGreenColor,
//         ),
//         body: testList.length == 0
//             ? noListData(Icons.library_add_outlined, '테스트 추가')
//             : searchTextEditingController.text.isEmpty
//                 ? ListView(children: testCardList)
//                 : ListView(children: searchTestCardList),
//         floatingActionButton: FloatingActionButton(
//           child: Icon(
//             Icons.add_rounded,
//             size: 40,
//           ),
//           onPressed: () async {
//             final Test? newTest = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => TestInputScreen(child: widget.child),
//               ),
//             );
//             if (newTest != null)
//               setState(() {
//                 // widget.child.testList.add(newTest);
//               });
//           },
//           backgroundColor: Colors.black,
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//         bottomSheet: buildTextFormField(
//           controller: searchTextEditingController,
//           hintText: '검색',
//           icon: Icon(
//             Icons.search_outlined,
//             color: Colors.black,
//             size: 30,
//           ),
//           onChanged: (str) {
//             setState(() {
//               // searchResult.clear();
//               // for (int i = 0; i < widget.child.testList.length; i++) {
//               //   bool flag = false;
//               //   if (widget.child.testList[i].title.contains(str)) flag = true;
//               //   if (flag) {
//               //     searchResult.add(widget.child.testList[i]);
//               //   }
//               // }
//               // searchTestCardList = convertChildToListTile(searchResult);
//             });
//           },
//           search: true,
//         ),
//       ),
//     );
//   }

//   List<Widget> convertChildToListTile(List<Test> testList) {
//     List<Widget> list = [];

//     if (testList.length != 0) {
//       testList.forEach((Test test) {
//         // 리스트 타일 생성
//         Widget listTile = buildListTile(
//           onTap: () {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //       builder: (context) => ChildChapterScreen(child: test)),
//             // );
//           },
//           trailing: buildToggleButtons(
//             text: ['복사', '설정'],
//             onPressed: (idx) async {
//               if (idx == 0) {
//                 setState(() async {
//                   // Test copyTest = Test(
//                   //   testId: await _store.updateId(AutoID.test),
//                   //   childId: widget.child.childId,
//                   //   date: test.date,
//                   //   title: test.title,
//                   // );
//                   // for (int i = 0;
//                   //     i < searchResult[index].contentList.length;
//                   //     i++) {
//                   //   copyTest.contentList.add(Content());
//                   //   copyTest.contentList[i].name =
//                   //       widget.child.testList[index].contentList[i].name;
//                   //   copyTest.contentList[i].result = null;
//                   // }
//                   // testList.add(copyTest);
//                   // searchTextEditingController.text = '';
//                 });
//               } else if (idx == 1) {
//                 // final Test? editTest = await Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (context) =>
//                 //         ChapterModifyScreen(searchResult[index]),
//                 //   ),
//                 // );
//                 // setState(() {
//                 //   if (editTest!.title == '') {
//                 //     widget.child.testList.removeAt(widget.child.testList
//                 //         .indexWhere(
//                 //             (element) => element.testId == test.testId));
//                 //   } else {
//                 //     widget.child.testList[widget.child.testList.indexWhere(
//                 //         (element) => element.testId == test.testId)] = editTest;
//                 //   }
//                 //   searchTextEditingController.text = '';
//                 // });
//               }
//             },
//           ),
//         );
//         list.add(listTile);
//       });
//     }
//     return list;
//   }
// }
// // ? ListView.builder(
//                 //     padding: EdgeInsets.only(bottom: 50),
//                 //     itemCount: widget.child.testList.length,
//                 //     itemBuilder: (BuildContext context, int index) {
//                 //       return buildListTile(
//                 //         titleText: widget.child.testList[index].title,
//                 //         subtitleText:
//                 //             widget.child.testList[index].date.toString(),
//                 //         onTap: () {
//                 //           Navigator.push(
//                 //             context,
//                 //             MaterialPageRoute(
//                 //               builder: (context) => ChildGetResultScreen(
//                 //                 widget.child,
//                 //                 widget.child.testList[index],
//                 //                 name: widget.child.name,
//                 //               ),
//                 //             ),
//                 //           );
//                 //         },
//                 //         trailing: buildToggleButtons(
//                 //           text: ['복사', '설정'],
//                 //           onPressed: (idx) async {
//                 //             if (idx == 0) {
//                 //               setState(() {
//                 //                 Test copyTest = Test(
//                 //                   widget.child.testList[index].testId,
//                 //                   widget.child.testList[index].childId,
//                 //                   widget.child.testList[index].date,
//                 //                   widget.child.testList[index].title,
//                 //                 );
//                 //                 for (int i = 0;
//                 //                     i <
//                 //                         widget.child.testList[index]
//                 //                             .testItemList.length;
//                 //                     i++) {
//                 //                   copyTest.testItemList.add(TestItem());
//                 //                   copyTest.contentList[i].name = widget.child
//                 //                       .testList[index].contentList[i].name;
//                 //                   copyTest.contentList[i].result = null;
//                 //                 }
//                 //                 for (int i = 0; i < 100; i++) {
//                 //                   bool flag = false;
//                 //                   for (int j = 0;
//                 //                       j < widget.child.testList.length;
//                 //                       j++)
//                 //                     if (widget.child.testList[j].chapterId ==
//                 //                         i) {
//                 //                       flag = true;
//                 //                       break;
//                 //                     }
//                 //                   if (!flag) {
//                 //                     copyTest.chapterId = i;
//                 //                     break;
//                 //                   }
//                 //                 }
//                 //                 widget.child.testList.add(copyTest);
//                 //               });
//                 //             } else if (idx == 1) {
//                 //               final Chapter? editChapter = await Navigator.push(
//                 //                 context,
//                 //                 MaterialPageRoute(
//                 //                   builder: (context) => ChapterModifyScreen(
//                 //                       widget.child.testList[index]),
//                 //                 ),
//                 //               );
//                 //               if (editChapter != null)
//                 //                 setState(() {
//                 //                   widget.child.testList[index] = editChapter;
//                 //                   if (editChapter.name == null) {
//                 //                     widget.child.testList.removeAt(index);
//                 //                   }
//                 //                 });
//                 //             }
//                 //           },
//                 //         ),
//                 //       );
//                 //     },
//                 //   )

//                 // : ListView.builder(
//                 //     padding: EdgeInsets.only(bottom: 50),
//                 //     itemCount: searchResult.length,
//                 //     itemBuilder: (BuildContext context, int index) {
//                 //       return buildListTile(
//                 //         titleText: searchResult[index].name,
//                 //         trailing: buildToggleButtons(
//                 //           text: ['복사', '설정'],
//                 //           onPressed: (idx) async {
//                 //             if (idx == 0) {
//                 //               setState(() {
//                 //                 Chapter copyChapter = Chapter();
//                 //                 copyChapter.name = searchResult[index].name;
//                 //                 copyChapter.date = searchResult[index].date;
//                 //                 for (int i = 0;
//                 //                     i < searchResult[index].contentList.length;
//                 //                     i++) {
//                 //                   copyChapter.contentList.add(Content());
//                 //                   copyChapter.contentList[i].name = widget.child
//                 //                       .testList[index].contentList[i].name;
//                 //                   copyChapter.contentList[i].result = null;
//                 //                 }
//                 //                 for (int i = 0; i < 100; i++) {
//                 //                   bool flag = false;
//                 //                   for (int j = 0;
//                 //                       j < widget.child.testList.length;
//                 //                       j++)
//                 //                     if (widget.child.testList[j].chapterId ==
//                 //                         i) {
//                 //                       flag = true;
//                 //                       break;
//                 //                     }
//                 //                   if (!flag) {
//                 //                     copyChapter.chapterId = i;
//                 //                     break;
//                 //                   }
//                 //                 }
//                 //                 widget.child.testList.add(copyChapter);
//                 //                 searchTextEditingController.text = '';
//                 //               });
//                 //             } else if (idx == 1) {
//                 //               final Chapter? editChapter = await Navigator.push(
//                 //                 context,
//                 //                 MaterialPageRoute(
//                 //                   builder: (context) =>
//                 //                       ChapterModifyScreen(searchResult[index]),
//                 //                 ),
//                 //               );
//                 //               setState(() {
//                 //                 if (editChapter!.name == null) {
//                 //                   widget.child.testList.removeAt(widget
//                 //                       .child.testList
//                 //                       .indexWhere((element) =>
//                 //                           element.chapterId ==
//                 //                           searchResult[index].chapterId));
//                 //                 } else {
//                 //                   widget.child.testList[widget.child.testList
//                 //                           .indexWhere((element) =>
//                 //                               element.chapterId ==
//                 //                               searchResult[index].chapterId)] =
//                 //                       editChapter;
//                 //                 }
//                 //                 searchTextEditingController.text = '';
//                 //               });
//                 //             }
//                 //           },
//                 //         ),
//                 //       );
//                 //     },
//                 //   ),