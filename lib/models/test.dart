class Test {
  final int testId;
  final int childId; 
  DateTime date;
  String title;
  bool isInput;

  Test({ required this.testId, required this.childId, required this.date, required this.title, required this.isInput});

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'date': date,
      'title': title,
      'isInput': isInput,
    };
  }

  String toString() {
    String str = '[Test ID: $testId & Child Id: $childId] - $title($date)';
    return str;
  }
}