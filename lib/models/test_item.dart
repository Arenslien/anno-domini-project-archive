class TestItem {
  final int testItemId; // PK
  final int testId; // FK
  final int childId;
  final String programField;
  final String subField;
  final String subItem;
  // String result;

  TestItem({ required this.testItemId, required this.testId, required this.childId, required this.programField, required this.subField, required this.subItem});

  Map<String, dynamic> toMap() {
    return {
      'testId': testId,
      'childId': childId,
      'programField': programField,
      'subField': subField,
      'subItem': subItem,
      // 'result': result,
    };
  }

  String toString() {
    return '[TestItem ID: $testItemId & Test ID: $testId] - $programField/$subField$subItem/';
  }

}