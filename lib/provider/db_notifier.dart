import 'package:aba_analysis_local/models/sub_item.dart';
import 'package:aba_analysis_local/services/db.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:flutter/foundation.dart';

import '../models/program_field.dart';

class DBNotifier extends ChangeNotifier {
  DBService _db = DBService();

  List<Child> _children = [];
  List<Test> _testList = [];
  List<TestItem> _testItemList = [];

  // 전역 관리하는 program field list
  List<ProgramField> _programFieldList = [];
  List<SubField> _subFieldList = [];
  List<SubItem> _subItemList = [];

  Future connectDB() async {
    await _db.initializeDB();
    refreshDB();
    notifyListeners();
  }

  Future refreshDB() async {
    _children = await _db.readAllChild();
    _testList = await _db.readAllTest();
    _testItemList = await _db.readAllTestItem();
    _programFieldList = await _db.readAllProgramField();
    _subFieldList = await _db.readAllSubFieldList();
    _subItemList = await _db.readAllSubItemList();
    notifyListeners();
  }

  // children 리스트 초기화
  Future<void> updateChildren() async {
    _children = await _db.readAllChild();
    notifyListeners();
  }

  // 아이 추가
  void addChild(Child child) {
    _children.add(child);
    notifyListeners();
  }

  // // 아이 찾기
  // Child readChild(int id) {
  //   Child child;
  //   for (Child c in _children) {
  //     if (c.id == id) {
  //       child = child
  //     }
  //   }

  //   return child;
  // }

  // 아이 삭제
  void removeChild(Child child) {
    _children.remove(child);
    notifyListeners();
  }

  // Test 리스트 초기화
  Future<void> updateTestList() async {
    _testList = await _db.readAllTest();
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
  Future<void> updateTestItemList() async {
    _testItemList = await _db.readAllTestItem();
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
        // testItem.setP(p);
        // testItem.setPlus(plus);
        // testItem.setMinus(minus);

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
        // if (testItem.testId == testId && testItem.result != null) {
        //   testItemList.add(testItem);
        // }
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
        // if (testItem.childId == childId && testItem.result != null) {
        //   testItemList.add(testItem);
        // }
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
      // if (testItem.result == '+') {
      //   cnt += 1;
      // }
    }
    return (cnt / testItemList.length * 100).toInt();
  }

  // 리스트 업데이트
  void updateProgramFieldList(List<ProgramField> programFieldList) {
    _programFieldList = programFieldList;
    notifyListeners();
  }

  // 입력받은 서브 필드 리스트를 Notifier에 있는 subFieldList에 업데이트
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
      allSubFieldNameList.add(subField.title);
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
    for (SubItem sI in _subItemList) {
      if (sI.subFieldId == subFieldId) {
        subItem = sI;
      }
    }
    print(subItem);
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
      if (subField.title == title) {
        id = subField.id;
        break;
      }
    }
    return id!;
  }

  // Getter Function
  List<ProgramField> get programFieldList => _programFieldList;
  List<SubField> get subFieldList => _subFieldList;
  List<SubItem> get subItemList => _subItemList;
  DBService? get database => _db;
  List<Child> get children => _children;
  List<Test> get testList => _testList;
  List<TestItem> get testItemList => _testItemList;
}
