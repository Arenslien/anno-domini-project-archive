import 'package:aba_analysis_local/models/program_field.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
import 'package:flutter/foundation.dart';

class FieldNotifier extends ChangeNotifier {
  // 전역 관리하는 program field list
  List<ProgramField> _programFieldList = [];

  // 전역 관리하는 sub field list
  List<SubField> _subFieldList = [];

  // Getter Function
  List<ProgramField> get programFieldList => _programFieldList;
  List<SubField> get subFieldList => _subFieldList;

  // 프로그램 필드 리스트 업데이트
  void updateProgramFieldList(List<ProgramField> programFieldList) {
    _programFieldList = programFieldList;
    notifyListeners();
  }

  // 프로그램 필드 리스트 업데이트
  void updateSubFieldList(List<SubField> subFieldList) {
    _subFieldList = subFieldList;
    notifyListeners();
  }

  List<String> readAllSubFieldName() {
    List<String> allSubFieldNameList = [];

    for (SubField subField in _subFieldList) {
      allSubFieldNameList.add(subField.title);
    }
    return allSubFieldNameList;
  }

  List<String> readAllSubFieldItemList() {
    List<String> allSubFieldItemList = [];

      for (SubField subField in _subFieldList) {
        for (String item in subField.subItemList)
          allSubFieldItemList.add(item);
      }
    
    return allSubFieldItemList;
  }

  // ProgramField Title에 속한 subField List 반환
  List<SubField> readSubFieldList(String title) {
    List<SubField> subFieldList = [];

    for (ProgramField programField in _programFieldList) {
      if (title == programField.title) {
        int id = programField.id;
        for (SubField subField in _subFieldList) {
          if (id == subField.programFieldId)
          subFieldList.add(subField);
        }
      }
    }

    return subFieldList;
  }
}
