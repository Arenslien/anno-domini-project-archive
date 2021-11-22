import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/provider/db_notifier.dart';
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
  List<Child> searchResult = [];
  TextEditingController searchTextEditingController = TextEditingController();

  @override
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
            },
          ),
          body: context.read<DBNotifier>().children.length == 0
              ? noListData(Icons.group, '아동 추가')
              : searchTextEditingController.text.isEmpty
                  ? ListView.separated(
                      itemCount: context.watch<DBNotifier>().children.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        return index < context.watch<DBNotifier>().children.length ? bulidChildListTile(context, context.watch<DBNotifier>().children[index]) : buildListTile(titleText: '');
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
