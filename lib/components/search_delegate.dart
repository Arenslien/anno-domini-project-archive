import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  final List<String> toSearchList;
  // List<String> toSearchStringList = [];
  List<String> resultList = [];
  Search(this.toSearchList);
  List<String> recentList = []; // 시간 되면 최근 검색목록 구현.

  @override
  List<Widget> buildActions(BuildContext context) {
    // 취소버튼
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close_rounded),
        onPressed: () {
          query = "";
        },
        color: Colors.black,
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // 뒤로가기 버튼
    return IconButton(
      icon: Icon(Icons.arrow_back_rounded),
      onPressed: () {
        close(context, ""); // pop과 비슷한 느낌. 결과인 query를 갖고 나갈 수 있다.
      },
      color: Colors.black,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 입력 후(키보드 자판에서 검색버튼을 눌렀을 때)에 빌드되는 리스트
    resultList = (toSearchList.where((inputText) {
      return inputText.contains(query);
    })).toList();
    return ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            resultList[index],
          ),
          leading: SizedBox(),
          onTap: () {
            query = resultList[index];
            close(context, query);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 입력 중에 빌드되는 추천리스트
    List<String> suggestionStringList = [];

    // query.isEmpty
    //     ? suggestionStringList = recentList //In the true case. 최근 검색목록을 가져옴.
    // 시간 가능하면 최근 검색목록 구현.

    suggestionStringList = (toSearchList.where(
      // In the false case

      (inputText) => inputText.contains(query),
    )).toList();

    return ListView.builder(
      itemCount: suggestionStringList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionStringList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: () {
            query = suggestionStringList[index];
            close(context, query);
          },
        );
      },
    );
  }
}
