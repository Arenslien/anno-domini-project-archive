import 'package:flutter/material.dart';
import 'package:show_me_the_graph/source/data_source.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  // 입력 데이터 관련 변수 선언
  late String title;
  List<bool> isChecked = [false, false, false, false, false, false, false, false, false, false];

  // Form 검증
  bool validateForm() {
    return title.isNotEmpty;
  }

  // 체크 박스 컬러 인터랙티브 관련 함수
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.amber;
    }
    return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    // 스마트폰 사이즈 가져오기
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("데이터 추가"),
        ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                  labelText: "제목",
                  labelStyle: TextStyle(color: Colors.black87),
                ),
                cursorColor: Colors.black87,
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '1',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Transform.scale(
                          scale: 2.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked[0], 
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked[0] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '2',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Transform.scale(
                          scale: 2.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked[1], 
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked[1] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '3',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Transform.scale(
                          scale: 2.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked[2], 
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked[2] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '4',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Transform.scale(
                          scale: 2.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked[3], 
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked[3] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '5',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Transform.scale(
                          scale: 2.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked[4], 
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked[4] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '6',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Transform.scale(
                          scale: 2.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked[5], 
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked[5] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '7',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Transform.scale(
                          scale: 2.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked[6], 
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked[6] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '8',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Transform.scale(
                          scale: 2.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked[7], 
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked[7] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '9',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Transform.scale(
                          scale: 2.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked[8], 
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked[8] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '10',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Transform.scale(
                          scale: 2.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked[9], 
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked[9] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (validateForm()) {
                    print(isChecked);
                    Navigator.pop(context, GraphData(title, isChecked));
                  };
                },
                child: Text("제출",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  )
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  minimumSize: Size(width * 0.9, 40.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
