import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis_local/services/db.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/components/search_bar.dart';
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
  late DBService db;

  late List<Child> children;

  List<Child> searchResult = [];
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0), () async {
      db = DBService(
        db: await openDatabase(
          join(await getDatabasesPath(), 'doggie_database.db'),
        ),
      );
      children = await db.readAllChild();
    });
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

                for (int i = 0; i < children.length; i++) {
                  bool flag = false;
                  if (children[i].name.contains(str)) flag = true;
                  if (flag) {
                    setState(() {
                      searchResult.add(children[i]);
                    });
                  }
                }
              },
              clear: () {
                setState(() {
                  searchTextEditingController.clear();
                });
              }),
          body: children.length == 0
              ? noListData(Icons.group, '아동 추가')
              : searchTextEditingController.text.isEmpty
                  ? ListView.separated(
                      itemCount: children.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        return index < children.length ? bulidChildListTile(context, children[index]) : buildListTile(titleText: '');
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(color: Colors.black);
                      },
                    )
                  : ListView.separated(
                      itemCount: searchResult.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        return index < searchResult.length ? bulidChildListTile(context, searchResult[index]) : buildListTile(titleText: '');
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(color: Colors.black);
                      },
                    ),
          floatingActionButton: bulidFloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChildInputScreen()),
              );
            },
          )),
    );
  }

  Widget bulidChildListTile(BuildContext context, Child child) {
    return buildListTile(
        titleText: child.name,
        subtitleText: '${child.age.toString()}세',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChildTestScreen(child: child)),
          );
          setState(() {
            searchTextEditingController.clear();
          });
        },
        trailing: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChildModifyScreen(child: child)),
            );
          },
          color: Colors.black,
        ));
  }
}
