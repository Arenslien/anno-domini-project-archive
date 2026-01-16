class GraphData {
  String _title;
  int _trueCount = 0;
  int _falseCount = 0;
  List<bool> _allCount = [];

  // GraphData 인스턴스를 만들기 위해서는 제목과 Conut리스트를 인자로 줘야 한다.
  // ex) GraphData('명사 "엄마"', [0, 0, 1, 1, 1, 1, 1, 0, 1, 1])
  GraphData(this._title, this._allCount) {
    for (var value in this._allCount) {
      if (value == true) {
        _trueCount++;
      } else {
        _falseCount++;
      }
    }
  }

  // Title을 return 하는 함수
  String getTitle() {
    return _title;
  }

  // trueCount를 return 하는 함수
  int getTrueCount() {
    return _trueCount;
  }

  // falseCount를 return 하는 함수
  int getFalseCount() {
    return _falseCount;
  }

  // allCount를 return 하는 함수
  List<bool> getCheckList() {
    return _allCount;
  }

  double getPercentage() {
    return _trueCount/(_trueCount + _falseCount) * 100;
  }
}