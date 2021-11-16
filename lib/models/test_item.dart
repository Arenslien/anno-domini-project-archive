class TestItem {
  int? id; // PK
  final int testId; // FK
  final int childId;
  final String programField;
  final String subField;
  final String subItem;
  String? result;

  TestItem({this.id, required this.testId, required this.childId, required this.programField, required this.subField, required this.subItem, required this.result});

  Map<String, dynamic> toMap() {
    return {
      'test-id': testId,
      'child-id': childId,
      'program-field': programField,
      'sub-field': subField,
      'sub-item': subItem,
      'result': result,
    };
  }

  String toString() {
    return '[TestItem ID: $id & Test ID: $testId] - $programField/$subField$subItem/ - $result';
  }
}
