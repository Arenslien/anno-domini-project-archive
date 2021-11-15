class SubField {
  final int id;
  final int programFieldId;
  final String title;
  final List<String> subItemList;

  SubField({required this.id, required this.programFieldId, required this.title, required this.subItemList});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'programFieldId': programFieldId,
      'title': title,
    };
    
    for (int i=0; i<subItemList.length; i++) {
      map['item$i'] = subItemList[i];
    }

    return map;
  }
}