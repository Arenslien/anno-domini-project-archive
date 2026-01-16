class TestItem {
  final int testItemId; // PK
  final int testId; // FK
  final int childId;
  final String programField;
  final String subField;
  final String subItem;
   
  int _p = 0;
  int _plus = 0;
  int _minus = 0;

  TestItem({ required this.testItemId, required this.testId, required this.childId, required this.programField, required this.subField, required this.subItem});

  Map<String, dynamic> toMap() {
    return {
      'test-item-id': testItemId,
      'test-id': testId,
      'child-id': childId,
      'program-field': programField,
      'sub-field': subField,
      'sub-item': subItem,
      'p': _p,
      'plus': _plus,
      'minus': _minus,
    };
  }

  String toString() {
    return '[TestItem ID: $testItemId & Test ID: $testId] - $programField/$subField$subItem/';
  }

  void countP() => this._p += 1;
  void countPlus() => this._plus += 1;
  void countMinus() => this._minus += 1;

  void setP(int cnt) => this._p = cnt;
  void setPlus(int cnt) => this._plus = cnt;
  void setMinus(int cnt) => this._minus = cnt;

  int get p => this._p;
  int get plus => this._plus;
  int get minus => this._minus;
}