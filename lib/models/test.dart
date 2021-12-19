class Test {
  final int testId;
  final int childId; 
  DateTime date;
  String title;
  bool isInput;

  Test({ required this.testId, required this.childId, required this.date, required this.title, required this.isInput});

  Map<String, dynamic> toMap() {
    return {
      'test-id': testId,
      'child-id': childId,
      'date': date,
      'title': title,
      'is-input': isInput,
    };
  }

  String toString() {
    String str = '[Test ID: $testId & Child Id: $childId] - $title($date)';
    return str;
  }
}