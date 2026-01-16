import 'package:flutter/material.dart';

class GroupBody extends StatefulWidget {
  @override
  _GroupBodyState createState() => _GroupBodyState();
}

class _GroupBodyState extends State<GroupBody> {
  @override
  Widget build(BuildContext context) {
    // 화면 사이즈
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "나의 공동체",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                )
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {

                }
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: size.height * 0.25,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green[400],
                      onPrimary: Colors.white,
                      padding: EdgeInsets.all(0),

                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/create_community');
                    },
                    child: Text(
                      "공동체 만들기",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


/*
그룹에 대한 CRUD 작업을 해봅시다.
먼저 그룹 생성

// 그룹 리스팅
if (user.group.length == 0) {
  그룹 찾기 or 그룹 만들기! 버튼? 제공 
} else {
  현재 내가 속한 그룹 리스팅 -> 좌우 스크롤링으로 보여주면 좋을 듯?
  그룹 사진 + 그룹 명
}

// 




*/