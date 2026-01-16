class ProgramField {
  final int id;
  final String title;
  ProgramField({ required this.id, required this.title });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }

  String toString() {
    return '[프로그램 영역] - ID:$id & TITLE: $title';
  }

  ProgramField.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'];
}
