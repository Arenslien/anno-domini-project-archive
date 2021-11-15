import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:aba_analysis_local/provider/test_notifier.dart';
import 'package:aba_analysis_local/provider/test_item_notifier.dart';
import 'package:aba_analysis_local/components/build_list_tile.dart';
import 'package:aba_analysis_local/components/build_no_list_widget.dart';
import 'package:aba_analysis_local/components/build_toggle_buttons.dart';
import 'package:aba_analysis_local/components/build_text_form_field.dart';
import 'package:aba_analysis_local/components/build_floating_action_button.dart';
import 'package:aba_analysis_local/screens/test_management/test_input_screen.dart';
import 'package:aba_analysis_local/screens/test_management/test_modify_screen.dart';
import 'package:aba_analysis_local/screens/child_management/child_get_result_screen.dart';

class ChildTestScreen extends StatefulWidget {
  final Child child;
  const ChildTestScreen({Key? key, required this.child}) : super(key: key);

  @override
  _ChildTestScreenState createState() => _ChildTestScreenState();
}

class _ChildTestScreenState extends State<ChildTestScreen> {
  _ChildTestScreenState();

  List<Test> searchResult = [];

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
        appBar: AppBar(
          title: Text(
            widget.child.name,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: mainGreenColor,
        ),
        body: context
                    .watch<TestNotifier>()
                    .getAllTestListOf(widget.child.childId, false)
                    .length ==
                0
            ? noListData(Icons.library_add_outlined, '테스트 추가')
            : searchTextEditingController.text.isEmpty
                ? ListView.separated(
                    // 검색한 결과가 없으면 다 출력
                    itemCount: context
                            .watch<TestNotifier>()
                            .getAllTestListOf(widget.child.childId, false)
                            .length +
                        1,
                    itemBuilder: (BuildContext context, int index) {
                      return index <
                              context
                                  .watch<TestNotifier>()
                                  .getAllTestListOf(widget.child.childId, false)
                                  .length
                          ? buildTestListTile(context
                              .watch<TestNotifier>()
                              .getAllTestListOf(
                                  widget.child.childId, false)[index])
                          : buildListTile(titleText: '');
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(color: Colors.black);
                    },
                  )
                : ListView.separated(
                    itemCount: searchResult.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return index < searchResult.length
                          ? buildTestListTile(searchResult[index])
                          : buildListTile(titleText: '');
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(color: Colors.black);
                    },
                  ),
        floatingActionButton: bulidFloatingActionButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestInputScreen(child: widget.child),
            ),
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomSheet: buildTextFormField(
          controller: searchTextEditingController,
          hintText: '검색',
          icon: Icon(
            Icons.search_outlined,
            color: Colors.black,
            size: 30,
          ),
          onChanged: (str) {
            setState(() {
              searchResult.clear();
            });
            for (int i = 0;
                i <
                    context
                        .read<TestNotifier>()
                        .getAllTestListOf(widget.child.childId, false)
                        .length;
                i++) {
              bool flag = false;
              if (context
                  .read<TestNotifier>()
                  .getAllTestListOf(widget.child.childId, false)[i]
                  .title
                  .contains(str)) flag = true;
              if (flag) {
                setState(() {
                  searchResult.add(context
                      .read<TestNotifier>()
                      .getAllTestListOf(widget.child.childId, false)[i]);
                });
              }
            }
          },
          search: true,
        ),
      ),
    );
  }

  Widget buildTestListTile(Test test) {
    return buildListTile(
      titleText: test.title,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChildGetResultScreen(child: widget.child, test: test),
          ),
        );
      },
      trailing: buildToggleButtons(
        text: ['복사', '수정'],
        onPressed: (idx) async {
          if (idx == 0) {
            // DB에 Test 추가
            // Test copiedTest = await store.copyTest(test);
            // TestNotifer에 추가
            // context.read<TestNotifier>().addTest(copiedTest);

            // 복사할 Test의 TestItemList 가져오기
            List<TestItem> testItemList = context
                .read<TestItemNotifier>()
                .getTestItemList(test.testId, true);

            for (TestItem testItem in testItemList) {
              // DB에 TestItem 추가
              // TestItem copiedTestItem =
              //     await store.copyTestItem(copiedTest.testId, copiedTest.childId, testItem);
              // 복사된 테스트 아이템 TestItem Notifier에 추가
              // context.read<TestItemNotifier>().addTestItem(copiedTestItem);
            }
            setState(() {
              searchTextEditingController.text = '';
            });
          } else if (idx == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TestModifyScreen(test: test),
              ),
            );
            setState(() {
              searchTextEditingController.text = '';
            });
          }
        },
      ),
    );
  }
}
