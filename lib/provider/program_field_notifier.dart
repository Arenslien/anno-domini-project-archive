import 'package:aba_analysis_local/models/program_field.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
import 'package:flutter/foundation.dart';

class ProgramFieldNotifier extends ChangeNotifier {
  // 전역 관리하는 program field list
  List<ProgramField> _programFieldList = [];

  // Getter Function
  List<ProgramField> get programFieldList => _programFieldList;

  // 프로그램 필드 리스트 업데이트
  void updateProgramFieldList(List<ProgramField> programFieldList) {
    _programFieldList = programFieldList;
    notifyListeners();
  }

  List<String> readAllSubFieldName() {
    List<String> allSubFieldNameList = [];

    for (ProgramField p in _programFieldList) {
      for (SubField s in p.subFieldList) {
        allSubFieldNameList.add(s.subFieldName);
      }
    }
    return allSubFieldNameList;
  }

  List<String> readAllSubFieldItemList() {
    List<String> allSubFieldItemList = [];

    for (ProgramField p in _programFieldList) {
      for (SubField s in p.subFieldList) {
        for (String subItemName in s.subItemList) {
          allSubFieldItemList.add(subItemName);
        }
      }
    }
    return allSubFieldItemList;
  }

  List<SubField> readSubFieldList(String title) {
    List<SubField> subFieldList = [];

    for (ProgramField programField in _programFieldList) {
      if (title == programField.title) {
        subFieldList = programField.subFieldList;
      }
    }

    return subFieldList;
  }
}
