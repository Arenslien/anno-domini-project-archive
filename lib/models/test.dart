class Test {
  int? id;
  final int childId;
  DateTime date;
  String title;
  bool isInput;

  Test({this.id, required this.childId, required this.date, required this.title, required this.isInput});

  Map<String, dynamic> toMap() {
    return {
      'child-id': childId,
      'date': date.toString(),
      'title': title,
      'is-input': isInput ? 1 : 0,
    };
  }

  String toString() {
    String str = '[Test ID: $id & Child Id: $childId] - $title($date)';
    return str;
  }
}
