import 'package:aba_analysis_local/provider/db_notifier.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/components/search_bar.dart';
import 'package:aba_analysis_local/components/build_list_tile.dart';
import 'package:aba_analysis_local/components/build_toggle_buttons.dart';
import 'package:aba_analysis_local/components/build_no_list_widget.dart';
import 'package:aba_analysis_local/screens/graph_management/select_program_screen.dart';
import 'package:aba_analysis_local/screens/graph_management/select_date_graph_screen.dart';
import 'package:provider/provider.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  List<Child> searchResult = [];
  TextEditingController searchTextEditingController = TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: searchBar(
              controller: searchTextEditingController,
              onChanged: (str) {
                setState(() {
                  searchResult.clear();
                });
                for (int i = 0; i < context.read<DBNotifier>().children.length; i++) {
                  bool flag = false;
                  if (context.read<DBNotifier>().children[i].name.contains(str)) flag = true;
                  if (flag) {
                    setState(() {
                      searchResult.add(context.read<DBNotifier>().children[i]);
                    });
                  }
                }
              },
              clear: () {
                setState(() {
                  searchTextEditingController.clear();
                });
              }),
          body: context.watch<DBNotifier>().children.length == 0
              ? noListData(Icons.auto_graph, '아동이 없습니다.')
              : searchTextEditingController.text.isEmpty
                  ? ListView.separated(
                      // 검색한 결과가 없으면 다 출력
                      itemCount: context.watch<DBNotifier>().children.length,
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(context.watch<DBNotifier>().children[index], context);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(color: Colors.black);
                      },
                    )
                  : ListView.separated(
                      // 검색 결과가 있으면
                      itemCount: searchResult.length, // 최종 선택한 아이 한명밖에 없음.
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(searchResult[index], context);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(color: Colors.black);
                      },
                    )),
    );
  }

  Widget dataTile(Child child, BuildContext context) {
    return buildListTile(
        titleText: child.name,
        subtitleText: '${child.age.toString()}세',
        trailing: buildToggleButtons(
          minWidth: 100,
          text: ['날짜 그래프', '아이템 그래프'],
          onPressed: (index) async {
            if (index == 0) {
              // Date Graph 클릭시
              List<Test> testList = await context.read<DBNotifier>().database!.readTestList(child.id!);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectDateScreen(
                            child: child,
                            testList: testList,
                          )));
            } else if (index == 1) {
              // Item Graph 클릭시
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectProgramScreen(
                          child: child,
                        )),
              );
            }
            setState(() {
              searchTextEditingController.clear();
            });
          },
        ));
  }
}
