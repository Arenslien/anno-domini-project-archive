import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/services/firestore.dart';

class SelectSubitemScreen extends StatefulWidget {
  final SubField subField;
  const SelectSubitemScreen({Key? key, required this.subField})
      : super(key: key);

  @override
  _SelectSubitemScreenState createState() => _SelectSubitemScreenState();
}

class _SelectSubitemScreenState extends State<SelectSubitemScreen> {
  _SelectSubitemScreenState();
  late String title;

  // 완료할 때 추가할 하위영역의 하위목록 리스트
  List<String> subitemList = [];

  FireStoreService store = FireStoreService();
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    subitemList = widget.subField.subItemList;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.subField.subFieldName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'KoreanGothic',
            ),
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
