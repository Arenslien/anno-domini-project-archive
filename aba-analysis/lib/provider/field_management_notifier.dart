import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/models/sub_item.dart';
import 'package:flutter/foundation.dart';

class FieldManagementNotifier extends ChangeNotifier {
  // 전역 관리하는 program field list
  List<ProgramField> _programFieldList = [];
  List<SubField> _subFieldList = [];
  List<SubItem> _subItemList = [];

  // Getter Function
  List<ProgramField> get programFieldList => _programFieldList;
  List<SubField> get subFieldList => _subFieldList;
  List<SubItem> get subItemList => _subItemList;

  // 리스트 업데이트
  void updateProgramFieldList(List<ProgramField> programFieldList) {
    _programFieldList = programFieldList;
    notifyListeners();
  }

  void updateSubFieldList(List<SubField> subFieldList) {
    _subFieldList = subFieldList;
    notifyListeners();
  }

  void updateSubItemList(List<SubItem> subItemList) {
    _subItemList = subItemList;
    notifyListeners();
  }

  List<String> readAllSubFieldName() {
    List<String> allSubFieldNameList = [];

    for (SubField subField in _subFieldList) {
      allSubFieldNameList.add(subField.subFieldName);
    }

    return allSubFieldNameList;
  }

  List<String> readAllSubFieldItemList() {
    List<String> allSubFieldItemList = [];

    for (SubItem subItem in _subItemList) {
      for (String item in subItem.subItemList) {
        allSubFieldItemList.add(item);
      }
    }

    return allSubFieldItemList;
  }

  // 해당 title을 프로그램 영역으로 가지고 있는 ProgramField 가져오기
  ProgramField? readProgramField(String title) {
    ProgramField? programField;

    for (ProgramField pf in _programFieldList) {
      if (pf.title == title) {
        programField = pf;
      }
    }

    return programField;
  }

  // 해당 title을 상위 영역으로 가지고 있는 SubFieldList 가져오기
  List<SubField> readSubFieldList(String title) {
    List<SubField> subFieldList = [];

    int programFieldId = convertProgramFieldTitleToId(title);

    for (SubField subField in _subFieldList) {
      if (subField.programFieldId == programFieldId) {
        subFieldList.add(subField);
      }
    }

    return subFieldList;
  }

  // 해당 title을 하위영역으로 가지고 있는 SubItemList 가져오기
  SubItem readSubItem(String title) {
    SubItem? subItem;
    int subFieldId = convertSubFieldTitleToId(title);
    print("id: " + subFieldId.toString());
    print("_subItemList: " + _subItemList.toString());
    for (SubItem sI in _subItemList) {
      if (sI.subFieldId == subFieldId) {
        subItem = sI;
        print(subItem.toString());
        break;
      }
    }
    return subItem!;
  }

  int convertProgramFieldTitleToId(String title) {
    int? id;
    for (ProgramField programField in _programFieldList) {
      if (programField.title == title) {
        id = programField.id;
        break;
      }
    }
    return id!;
  }

  int convertSubFieldTitleToId(String title) {
    int? id;
    for (SubField subField in _subFieldList) {
      if (subField.subFieldName == title) {
        id = subField.id;
        break;
      }
    }
    return id!;
  }
}
