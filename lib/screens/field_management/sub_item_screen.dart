import 'package:flutter/material.dart';
import 'package:aba_analysis_local/constants.dart';

class SubItemScreen extends StatefulWidget {
  final List<String> subItemList;
  final String subFieldName;
  final int index;
  const SubItemScreen(
      {Key? key,
      required this.subItemList,
      required this.index,
      required this.subFieldName})
      : super(key: key);

  @override
  _SubItemScreenState createState() => _SubItemScreenState();
}

class _SubItemScreenState extends State<SubItemScreen> {
  _SubItemScreenState();

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
            widget.subFieldName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
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
                itemCount: widget.subItemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      "${index + 1}. " + widget.subItemList[index],
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
                            maxHeight: 64,
                          ),
                          child: Image.asset('asset/sub_list_icon.png',
                              fit: BoxFit.fill),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 44,
                            minHeight: 48,
                            maxWidth: 44,
                            maxHeight: 48,
                          ),
                          child: Image.asset('asset/basic_icon.png',
                              fit: BoxFit.fill),
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
