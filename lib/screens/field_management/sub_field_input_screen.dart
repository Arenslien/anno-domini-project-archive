import 'package:aba_analysis_local/models/sub_item.dart';
import 'package:aba_analysis_local/provider/db_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
// import 'package:aba_analysis_local/services/firestore.dart';
import 'package:aba_analysis_local/models/program_field.dart';
// import 'package:aba_analysis_local/provider/field_management_notifier.dart';
import 'package:aba_analysis_local/components/build_text_form_field.dart';

class SubFieldInputScreen extends StatefulWidget {
  final ProgramField program;
  const SubFieldInputScreen({Key? key, required this.program}) : super(key: key);

  @override
  _SubFieldInputScreenState createState() => _SubFieldInputScreenState();
}

class _SubFieldInputScreenState extends State<SubFieldInputScreen> {
  _SubFieldInputScreenState();
  late String title;

  // 완료할 때 추가할 하위영역의 하위목록 리스트
  List<String> subitemList = List<String>.generate(10, (index) => "");
  Set<String> subItemSet = {};
  late String subFieldName;
  final formkey = GlobalKey<FormState>();
  // FireStoreService store = FireStoreService();
  final textController = TextEditingController();

  bool flag = false;

  @override
  void initState() {
    super.initState();
  }

  bool isCheckDup(String checkDup) {
    List<String> s = context.read<DBNotifier>().readAllSubFieldItemList();
    if (s.contains(checkDup)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formkey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '하위영역 추가',
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
            actions: [
              IconButton(
                icon: Icon(
                  Icons.check_rounded,
                  color: Colors.black,
                ),
                onPressed: () async {
                  print(subitemList);
                  // if (formkey.currentState!.validate() && !flag) {
                  //   flag = true;
                  //   SubField addSub = SubField(
                  //     id: await store.updateId(AutoID.subField),
                  //     programFieldId: widget.program.id,
                  //     subFieldName: subFieldName,
                  //   );
                  //   // DB에 서브필드 추가
                  //   await store.addSubField(addSub);
                  //   // Subfield를 Notifier에 추가
                  //   context.read<DBNotifier>().updateSubFieldList(await store.readAllSubField());

                  //   // DB에 서브 아이템 추가
                  //   SubItem subItem = SubItem(
                  //     id: await store.updateId(AutoID.subItem),
                  //     subFieldId: addSub.id,
                  //     subItemList: subitemList,
                  //   );
                  //   await store.addSubItem(subItem);
                  //   // Provider에 서브 아이템 추가
                  //   context.read<DBNotifier>().updateSubItemList(await store.readAllSubItem());
                  //   // 초기화
                  //   subitemList = List<String>.generate(10, (index) => "");

                  //   Navigator.pop(context);
                  // }
                },
              ),
            ],
            backgroundColor: mainGreenColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                buildTextFormField(
                  text: '하위영역 이름',
                  onChanged: (val) {
                    setState(() {
                      subFieldName = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '하위영역 이름을 입력해주세요.';
                    }

                    for (String subFieldName in context.read<DBNotifier>().readAllSubFieldName()) {
                      if (subFieldName == val) {
                        return '중복된 하위영역 이름입니다.';
                      }
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('하위 목록'),
                    ],
                  ),
                ),
                // 하위 목록 아래부분 실제 하위목록들을 그려준다.
                buildTextFormField(
                  text: '1번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[0] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '1번 하위목록을 입력해주세요.';
                    }
                    int i = 0;
                    while (i < 10) {
                      if (val == subitemList[i] && i != 0) {
                        return "중복된 이름입니다.";
                      }
                      i++;
                    }
                    if (isCheckDup(val)) {
                      return '다른 하위목록의 이름과 중복되었습니다.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '2번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[1] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '2번 하위목록을 입력해주세요.';
                    }
                    int i = 0;
                    while (i < 10) {
                      if (val == subitemList[i] && i != 1) {
                        return "중복된 이름입니다.";
                      }
                      i++;
                    }
                    if (isCheckDup(val)) {
                      return '다른 하위목록의 이름과 중복되었습니다.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '3번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[2] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '3번 하위목록을 입력해주세요.';
                    }
                    int i = 0;
                    while (i < 10) {
                      if (val == subitemList[i] && i != 2) {
                        return "중복된 이름입니다.";
                      }
                      i++;
                    }
                    if (isCheckDup(val)) {
                      return '다른 하위목록의 이름과 중복되었습니다.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '4번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[3] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '4번 하위목록을 입력해주세요.';
                    }
                    int i = 0;
                    while (i < 10) {
                      if (val == subitemList[i] && i != 3) {
                        return "중복된 이름입니다.";
                      }
                      i++;
                    }
                    if (isCheckDup(val)) {
                      return '다른 하위목록의 이름과 중복되었습니다.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '5번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[4] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '5번 하위목록을 입력해주세요.';
                    }
                    int i = 0;
                    while (i < 10) {
                      if (val == subitemList[i] && i != 4) {
                        return "중복된 이름입니다.";
                      }
                      i++;
                    }
                    if (isCheckDup(val)) {
                      return '다른 하위목록의 이름과 중복되었습니다.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '6번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[5] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '6번 하위목록을 입력해주세요.';
                    }
                    int i = 0;
                    while (i < 10) {
                      if (val == subitemList[i] && i != 5) {
                        return "중복된 이름입니다.";
                      }
                      i++;
                    }
                    if (isCheckDup(val)) {
                      return '다른 하위목록의 이름과 중복되었습니다.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '7번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[6] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '7번 하위목록을 입력해주세요.';
                    }
                    int i = 0;
                    while (i < 10) {
                      if (val == subitemList[i] && i != 6) {
                        return "중복된 이름입니다.";
                      }
                      i++;
                    }
                    if (isCheckDup(val)) {
                      return '다른 하위목록의 이름과 중복되었습니다.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '8번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[7] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '8번 하위목록을 입력해주세요.';
                    }
                    int i = 0;
                    while (i < 10) {
                      if (val == subitemList[i] && i != 7) {
                        return "중복된 이름입니다.";
                      }
                      i++;
                    }
                    if (isCheckDup(val)) {
                      return '다른 하위목록의 이름과 중복되었습니다.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '9번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[8] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '9번 하위목록을 입력해주세요.';
                    }
                    int i = 0;
                    while (i < 10) {
                      if (val == subitemList[i] && i != 8) {
                        return "중복된 이름입니다.";
                      }
                      i++;
                    }
                    if (isCheckDup(val)) {
                      return '다른 하위목록의 이름과 중복되었습니다.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '10번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[9] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '10번 하위목록을 입력해주세요.';
                    }
                    int i = 0;
                    while (i < 10) {
                      if (val == subitemList[i] && i != 9) {
                        return "중복된 이름입니다.";
                      }
                      i++;
                    }
                    if (isCheckDup(val)) {
                      return '다른 하위목록의 이름과 중복되었습니다.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
