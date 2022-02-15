import 'package:aba_analysis_local/provider/db_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis_local/components/search_delegate.dart';
import 'package:aba_analysis_local/components/select_appbar.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/components/build_list_tile.dart';
import 'package:aba_analysis_local/components/build_toggle_buttons.dart';
import 'package:aba_analysis_local/components/build_no_list_widget.dart';
import 'package:aba_analysis_local/screens/graph_management/select_program_screen.dart';
import 'package:aba_analysis_local/screens/graph_management/select_date_graph_screen.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  String selectedChildName = "";
  Map<String, Child> childNameAndChildMap = {};
  late Child selectedChild;
  void initState() {
    super.initState();
    //childList 초기화
  }

  @override
  Widget build(BuildContext context) {
    for (Child c in context.watch<DBNotifier>().children) {
      childNameAndChildMap.addAll({c.name: c});
    }
    IconButton searchButton = IconButton(
      // 검색버튼. 전역변수값을 변경해야되서 해당 스크린에서 정의했음.
      icon: Icon(Icons.search),
      onPressed: () async {
        final finalResult = await showSearch(
            context: context,
            delegate: Search(childNameAndChildMap.keys.toList()));
        setState(() {
          if (childNameAndChildMap.containsKey(finalResult)) {
            selectedChildName = finalResult;
            selectedChild = childNameAndChildMap[selectedChildName]!;
          } else {
            selectedChildName = "";
          }
        });
      },
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: selectAppBar(context, "통합 그래프 보기",
              searchButton: searchButton, isMain: true),
          // searchBar(
          //     controller: searchTextEditingController,
          //     onChanged: (str) {
          //       setState(() {
          //         searchResult.clear();
          //       });
          //       for (int i = 0; i < context.read<DBNotifier>().children.length; i++) {
          //         bool flag = false;
          //         if (context.read<DBNotifier>().children[i].name.contains(str)) flag = true;
          //         if (flag) {
          //           setState(() {
          //             searchResult.add(context.read<DBNotifier>().children[i]);
          //           });
          //         }
          //       }
          //     },
          //     clear: () {
          //       setState(() {
          //         searchTextEditingController.clear();
          //       });
          //     }),
          body: childNameAndChildMap.length == 0
              ? noListData(Icons.auto_graph, '아동이 없습니다.')
              : selectedChildName == ""
                  ? ListView.separated(
                      // 검색한 결과가 없으면 다 출력
                      itemCount: childNameAndChildMap.keys.toList().length,
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(
                            childNameAndChildMap.values.toList()[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(color: Colors.black);
                      },
                    )
                  : ListView.separated(
                      // 검색 결과가 있으면
                      itemCount: 1, // 최종 선택한 아이 한명밖에 없음.
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(selectedChild);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(color: Colors.black);
                      },
                    )),
    );
  }

  Widget dataTile(Child child) {
    return buildListTile(
        titleText: child.name,
        subtitleText: '${child.age.toString()}세',
        trailing: buildToggleButtons(
          minWidth: 100,
          text: ['날짜 그래프', '아이템 그래프'],
          onPressed: (index) {
            if (index == 0) {
              // Date Graph 클릭시
              List<Test> testList = context
                  .read<DBNotifier>()
                  .getAllTestListOf(child.id, true);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             SelectDateScreen(child: child, testList: testList)));
            } else if (index == 1) {
              // Item Graph 클릭시
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => SelectProgramScreen(
              //             child: child,
              //           )),
              // );
            }
          },
        ));
  }
}
