import 'package:aba_analysis_local/services/db.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:flutter/foundation.dart';

class DBNotifier extends ChangeNotifier {
  DBService _db = DBService();

  List<Child> _children = [];
  List<Test> _testList = [];
  List<TestItem> _testItemList = [];
  List<SubField> _subFieldList = [];

  Future connectDB() async {
    await _db.initDatabase();
    refreshDB();
    notifyListeners();
  }

  Future refreshDB() async {
    _children = await _db.readAllChild();
    _testList = await _db.readAllTest();
    _testItemList = await _db.readAllTestItem();
    _subFieldList = await _db.readAllSubFieldList();
    notifyListeners();
  }

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

  void updateTestItem(int testItemId, String result) {
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
        print(testItem.testId);
        if (testItem.testId == testId) {
          testItemList.add(testItem);
        }
      });
    } else {
      _testItemList.forEach((TestItem testItem) {
        if (testItem.testId == testId && testItem.result != null) {
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
        if (testItem.childId == childId && testItem.result != null) {
          testItemList.add(testItem);
        }
      });
    }

    return testItemList;
  }

  int getAverage(int testId) {
    List<TestItem> testItemList = getTestItemList(testId, false);
    if (testItemList.length == 0) {
      return 0;
    }
    int cnt = 0;
    for (TestItem testItem in testItemList) {
      if (testItem.result == '+') {
        cnt += 1;
      }
    }
    return (cnt / testItemList.length * 100).toInt();
  }

  List<String> readAllSubFieldName() {
    List<String> allSubFieldNameList = [];

    for (SubField s in _subFieldList) {
      allSubFieldNameList.add(s.title);
    }

    return allSubFieldNameList;
  }

  List<String> readAllSubFieldItemList() {
    List<String> allSubFieldItemList = [];

    for (SubField s in _subFieldList) {
      for (String subItemName in s.subItemList) {
        allSubFieldItemList.add(subItemName);
      }
    }
    return allSubFieldItemList;
  }

  List<SubField> readSubFieldList(int id) {
    List<SubField> subFieldList = [];

    for (SubField subField in _subFieldList) {
      if (id == subField.programFieldId) {
        subFieldList.add(subField);
      }
    }

    return subFieldList;
  }

  DBService? get database => _db;
  List<Child> get children => _children;
  List<Test> get testList => _testList;
  List<TestItem> get testItemList => _testItemList;
  List<SubField> get subFieldList => _subFieldList;
}
