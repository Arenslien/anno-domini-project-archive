import 'package:flutter/material.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/models/sub_field.dart';

class SelectSubitemScreen extends StatefulWidget {
  final SubField subField;
  final int index;
  const SelectSubitemScreen({Key? key, required this.subField, required this.index}) : super(key: key);

  @override
  _SelectSubitemScreenState createState() => _SelectSubitemScreenState();
}

class _SelectSubitemScreenState extends State<SelectSubitemScreen> {
  late String title;

  // 완료할 때 추가할 하위영역의 하위목록 리스트
  List<String> subitemList = [];

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // subitemList = widget.subField.subItemList;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          // title: Text(
          //   widget.subField.title,
          //   style: TextStyle(
          //     color: Colors.black,
          //     fontSize: 16,
          //     fontFamily: 'KoreanGothic',
          //   ),
          // ),
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
        body: Column(
          children: [
            // 하위 목록 아래부분 실제 하위목록들을 그려준다.
            Flexible(
              child: ListView.builder(
                itemCount: subitemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      "${index + 1}. " + subitemList[index],
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'KoreanGothic',
                      ),
                    ),
                    trailing: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 44,
                            minHeight: 48,
                            maxWidth: 64,
                            maxHeight: 48,
                          ),
                          child: Image.asset('asset/sub_list_icon.png', fit: BoxFit.fill),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 44,
                            minHeight: 48,
                            maxWidth: 64,
                            maxHeight: 48,
                          ),
                          child: widget.index == 0 ? Image.asset('asset/basic_icon.png', fit: BoxFit.fill) : Image.asset('asset/add_icon.png', fit: BoxFit.fill),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
