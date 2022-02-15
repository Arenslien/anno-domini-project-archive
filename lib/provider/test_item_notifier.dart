import 'package:aba_analysis_local/models/test_item.dart';
import 'package:flutter/foundation.dart';

class TestItemNotifier extends ChangeNotifier {
  // 아이들의 테스트들을 관리하는 리스트
  List<TestItem> _testItemList = [];

  // TestItem 리스트 초기화
  void updateTestItemList(List<TestItem> testItemList) {
    _testItemList = testItemList;
    notifyListeners();
  }

  // TestItem 추가
  void addTestItem(TestItem testItem) {
    _testItemList.add(testItem);
    notifyListeners();
  }

  void updateTestItem(int testItemId, int p, int plus, int minus) {
    for (TestItem testItem in _testItemList) {
      if (testItem.testItemId == testItemId) {
        testItem.setP(p);
        testItem.setPlus(plus);
        testItem.setMinus(minus);
      }
    }
  }

  // TestItem 삭제
  void removeTestItem(TestItem testItem) {
    _testItemList.remove(testItem);
    notifyListeners();
  }

  // TestItem 불러오기
  List<TestItem> getTestItemList(int testId, bool nullValue) {
    List<TestItem> testItemList = [];
    if (nullValue) {
      _testItemList.forEach((TestItem testItem) {
        if (testItem.testId == testId) {
          testItemList.add(testItem);
        }
      });
    } else {
      _testItemList.forEach((TestItem testItem) {
        if (testItem.testId == testId &&
            (testItem.p + testItem.plus + testItem.minus != 0)) {
          testItemList.add(testItem);
        }
      });
    }
    return testItemList;
  }

  List<TestItem> getTestItemListFromChildId(int childId, bool nullValue) {
    List<TestItem> testItemList = [];

    if (nullValue) {
      _testItemList.forEach((TestItem testItem) {
        print(testItem.childId);
        if (testItem.childId == childId) {
          testItemList.add(testItem);
        }
      });
    } else {
      _testItemList.forEach((TestItem testItem) {
        if (testItem.childId == childId &&
            (testItem.p + testItem.plus + testItem.minus != 0)) {
          testItemList.add(testItem);
        }
      });
    }

    return testItemList;
  }

  // int getAverage(int testId) {
  //   List<TestItem> testItemList = getTestItemList(testId, false);
  //   if (testItemList.length == 0) {
  //     return 0;
  //   }
  //   int cnt = 0;
  //   for (TestItem testItem in testItemList) {
  //     if (testItem.p == '+') {
  //       cnt += 1;
  //     }
  //   }
  //   return (cnt / testItemList.length * 100).toInt();
  // }

  // GETTER FUNCTION: TestItem List 제공
  List<TestItem> get testItemList => _testItemList;
}
