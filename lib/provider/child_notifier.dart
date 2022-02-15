import 'package:flutter/foundation.dart';
import 'package:aba_analysis_local/models/child.dart';

class ChildNotifier extends ChangeNotifier {
  // 교사가 맡고 있는 아이들을 관리하는 리스트
  List<Child> _children = [];

  // children 리스트 초기화
  void updateChildren(List<Child> children) {
    _children = children;
    notifyListeners();
  }

  // 아이 추가
  void addChild(Child child) {
    _children.add(child);
    notifyListeners();
  }

  // 아이 삭제
  void removeChild(Child child) {
    _children.remove(child);
    notifyListeners();
  }

  Child? getChild(int childId) {
    // 시간 되면 -> 아이들정렬을 id ㅅ순으로 해서 이진 탐색
    for (Child child in _children) {
      if (child.id == childId) {
        return child;
      }
    }
    return null;
  }

  // GETTER FUNCTION: children List 제공
  List<Child> get children => _children;
}
