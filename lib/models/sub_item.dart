import 'dart:core';

class SubItem {
  final int id; // PK
  final int subFieldId; // FK
  final List<String> subItemList;
  SubItem({ required this.id, required this.subFieldId, required this.subItemList });

  // DB -> 넘김
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['subFieldId'] = subFieldId;
    for (int i=0; i<subItemList.length; i++) {
      map['item${i+1}'] = subItemList[i];
    }
    return map;
  }

  String toString() {
    String returnString = '[하위 목록] - id=$id / subFieldId=$subFieldId';
    for (int i=0; i<subItemList.length; i++) {
      returnString += ' / ${subItemList[i]}';
    }
    return returnString;
  }
}