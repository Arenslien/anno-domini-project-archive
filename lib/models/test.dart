import 'package:intl/intl.dart';

class Test {
  final int testId;
  final int childId;
  DateTime date;
  String title;
  bool isInput;
  String memo;

  Test({required this.testId, required this.childId, required this.date, required this.title, required this.isInput, required this.memo});

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'date': DateFormat('yyyyMMdd').format(date),
      'title': title,
      'isInput': isInput ? 1 : 0,
      'memo': memo
    };
  }

  String toString() {
    String str = '[Test ID: $testId & Child Id: $childId] - $title($date)';
    return str;
  }
}
