import 'package:aba_analysis_local/provider/db_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/provider/child_notifier.dart';
import 'package:aba_analysis_local/components/select_appbar.dart';
import 'package:aba_analysis_local/components/search_delegate.dart';
import 'package:aba_analysis_local/components/build_list_tile.dart';
import 'package:aba_analysis_local/components/build_no_list_widget.dart';
import 'package:aba_analysis_local/components/build_floating_action_button.dart';
import 'package:aba_analysis_local/screens/child_management/child_test_screen.dart';
import 'package:aba_analysis_local/screens/child_management/child_input_screen.dart';
import 'package:aba_analysis_local/screens/child_management/child_modify_screen.dart';

class ChildMainScreen extends StatefulWidget {
  const ChildMainScreen({Key? key}) : super(key: key);

  @override
  _ChildMainScreenState createState() => _ChildMainScreenState();
}

class _ChildMainScreenState extends State<ChildMainScreen> {
  String selectedChildName = "";
  Map<String, Child> childNameAndChildMap = {};
  late Child selectedChild;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (Child c in context.read<DBNotifier>().children) {
      childNameAndChildMap.addAll({c.name: c});
    }
    IconButton searchButton = IconButton(
      // 검색버튼. 전역변수값을 변경해야되서 해당 스크린에서 정의했음.
      icon: Icon(Icons.search),
      onPressed: () async {
        final finalResult = await showSearch(
          context: context,
          delegate: Search(childNameAndChildMap.keys.toList()),
        );
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
        appBar: selectAppBar(context, "아동관리", searchButton: searchButton, isMain: true),
        // searchBar(
        //     controller: searchTextEditingController,
        //     onChanged: (str) {
        //       setState(() {
        //         searchResult.clear();
        //       });
        //       for (int i = 0;
        //           i < context.read<ChildNotifier>().children.length;
        //           i++) {
        //         bool flag = false;
        //         if (context
        //             .read<ChildNotifier>()
        //             .children[i]
        //             .name
        //             .contains(str)) flag = true;
        //         if (flag) {
        //           setState(() {
        //             searchResult
        //                 .add(context.read<ChildNotifier>().children[i]);
        //           });
        //         }
        //       }
        //     },
        //     clear: () {
        //       setState(() {
        //         searchTextEditingController.clear();
        //       });
        //     }),
        body: context.watch<DBNotifier>().children.length == 0
            ? noListData(Icons.group, '아동 추가')
            : selectedChildName == ""
                ? ListView.separated(
                    itemCount: childNameAndChildMap.keys.toList().length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return index < childNameAndChildMap.keys.toList().length ? bulidChildListTile(childNameAndChildMap.values.toList()[index]) : buildListTile(titleText: '');
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(color: Colors.black);
                    },
                  )
                : ListView.separated(
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return index < 1 ? bulidChildListTile(selectedChild) : buildListTile(titleText: '');
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(color: Colors.black);
                    },
                  ),
        floatingActionButton: bulidFloatingActionButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ChildInputScreen()),
            // );
          },
        ),
      ),
    );
  }

  Widget bulidChildListTile(Child child) {
    return buildListTile(
        titleText: child.name,
        subtitleText: '${child.age.toString()}세',
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ChildTestScreen(child: child)),
          // );
        },
        trailing: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ChildModifyScreen(child: child)),
            // );
          },
          color: Colors.black,
        ));
  }
}
