class SubField {
  final int id; // PK
  final int programFieldId; // FK
  final String subFieldName;
  SubField(
      {required this.id,
      required this.programFieldId,
      required this.subFieldName});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'programFieldId': programFieldId,
      'subFieldName': subFieldName,
    };
  }

  String toString() {
    return '[하위 영역] - ID:$id & SubFieldName: $subFieldName';
  }
}
