class SubField {
  final int id; // PK
  final int programFieldId; // FK
  final String title;


  SubField(
      {required this.id,
      required this.programFieldId,
      required this.title});

  Map<String, dynamic> toMap() {
    return {
      'programFieldId': programFieldId,
      'title': title,
    };
  }

  String toString() {
    return '[하위 영역] - ID:$id & title: $title';
  }

  SubField.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        programFieldId = res['programFieldId'],
        title = res['title'];

}
