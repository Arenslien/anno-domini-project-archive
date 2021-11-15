import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/components/search_bar.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_no_list_widget.dart';
import 'package:aba_analysis/screens/graph_management/select_program_screen.dart';
import 'package:aba_analysis/screens/graph_management/select_date_graph_screen.dart';

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
    //childList 초기화

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
                for (int i = 0; i < context.read<ChildNotifier>().children.length; i++) {
                  bool flag = false;
                  if (context.read<ChildNotifier>().children[i].name.contains(str)) flag = true;
                  if (flag) {
                    setState(() {
                      searchResult.add(context.read<ChildNotifier>().children[i]);
                    });
                  }
                }
              },
              clear: () {
                setState(() {
                  searchTextEditingController.clear();
                });
              }),
          body: context.read<ChildNotifier>().children.length == 0
              ? noListData(Icons.auto_graph, '아동이 없습니다.')
              : searchTextEditingController.text.isEmpty
                  ? ListView.separated(
                      // 검색한 결과가 없으면 다 출력
                      itemCount: context.watch<ChildNotifier>().children.length,
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(
                            context.watch<ChildNotifier>().children[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(color: Colors.black);
                      },
                    )
                  : ListView.separated(
                      // 검색 결과가 있으면
                      itemCount: searchResult.length, // 최종 선택한 아이 한명밖에 없음.
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(searchResult[index]);
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
                  .read<TestNotifier>()
                  .getAllTestListOf(child.childId, true);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SelectDateScreen(child: child, testList: testList)));
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
