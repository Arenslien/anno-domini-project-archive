import 'package:aba_analysis_local/models/test.dart';
import 'package:flutter/foundation.dart';

class TestNotifier extends ChangeNotifier {
  // 아이들의 테스트들을 관리하는 리스트
  List<Test> _testList = [];

  // Test 리스트 초기화
  void updateTestList(List<Test> testList) {
    _testList = testList;
    notifyListeners();
  }

  // Test 추가
  void addTest(Test test) {
    _testList.add(test);
    notifyListeners();
  }

  void updateTest(int testId, DateTime date, String title, bool isInput) {
    _testList.forEach((Test test) {
      if (test.testId == testId) {
        test.title = title;
        test.date = date;
        test.isInput = isInput;
      }
    });
    notifyListeners();
  }

  // Test 삭제
  void removeTest(Test test) {
    _testList.remove(test);
    notifyListeners();
  }

  List<Test> getAllTestListOf(int childId, bool isInput) {
    List<Test> testListOfChild = [];

    if (isInput) {
      _testList.forEach((test) {
        if (test.childId == childId && test.isInput) {
          print("테스트 ${test.title}의  isinput: ${test.isInput}");
          testListOfChild.add(test);
        }
      });
    } else {
      _testList.forEach((test) {
        if (test.childId == childId) {
          testListOfChild.add(test);
        }
      });
    }

    return testListOfChild;
  }

  // GETTER FUNCTION: Test List 제공
  List<Test> get testList => _testList;
}
