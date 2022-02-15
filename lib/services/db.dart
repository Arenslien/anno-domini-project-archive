import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

class DBService {
  Future<Database> initializeDB() async {
    return await openDatabase(
      Path.join(await getDatabasesPath(), 'aba_analysis.db'),
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE child(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, birthday TEXT, gender TEXT)");
        await db.execute("CREATE TABLE test(id INTEGER PRIMARY KEY AUTOINCREMENT, id INTEGER, date TEXT, title TEXT, isInput INTEGER)");
        await db.execute("CREATE TABLE testItem(id INTEGER PRIMARY KEY AUTOINCREMENT, testId INTEGER, id INTEGER, programField TEXT, subField TEXT, subItem TEXT, result TEXT)");
        await db.execute("CREATE TABLE programField(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)");
        await db.execute("CREATE TABLE subField(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, programFieldId INTEGER, item1 TEXT, item2 TEXT, item3 TEXT, item4 TEXT, item5 TEXT, item6 TEXT, item7 TEXT, item8 TEXT, item9 TEXT, item10 TEXT)");
      },
      version: 1,
    );
  }
  //=======================================================================================
  //                          Firebase 연동 - 아이들 관련 함수들
  //=======================================================================================

  Future<void> createChild(Child child) async {
    final db = await initializeDB();
    await db.insert(
      'child',
      child.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 교사가 맡고 있는 모든 아이들 데이터 가져오기
  Future<List<Child>> readAllChild() async {
    // 모든 Child 얻기 위해 테이블에 질의합니다.
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('child');
    return queryResult.map((e) => Child.fromMap(e)).toList();
  }

  Future<Child?> readChild(int id) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'child',
      where: 'id = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return Child(
        id: maps[i]['id'],
        name: maps[i]['name'],
        birthday: DateTime.parse(maps[i]['birthday']),
        gender: maps[i]['gender'],
      );
    })[0];
  }

  Future updateChild(Child child) async {
    final db = await initializeDB();

    await db.update(
      'child',
      child.toMap(),
      // Dog의 id가 일치하는 지 확인합니다.
      where: "id = ?",
      // Dog의 id를 whereArg로 넘겨 SQL injection을 방지합니다.
      whereArgs: [child.id],
    );
  }

  Future deleteChild(int id) async {
    final db = await initializeDB();

    await db.delete(
      'child',
      // 특정 dog를 제거하기 위해 `where` 절을 사용하세요
      where: "id = ?",
      // Dog의 id를 where의 인자로 넘겨 SQL injection을 방지합니다.
      whereArgs: [id],
    );
  }

  //=======================================================================================
  //                          Firebase 연동 - 하위 영역 관련 함수들
  //=======================================================================================
  Future addSubField(SubField subField) async {
    final db = await initializeDB();

    await db.insert(
      'subField',
      subField.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SubField>> readSubFieldList(int id) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'subField',
      where: "programFieldId = ?",
      whereArgs: [id],
    );

    return List.generate(maps.length, (i) {
      List<String> subItemList = [];
      for (int j = 0; j < 10; j++) {
        subItemList.add(maps[i]['item${j + 1}']);
      }

      return SubField(
        id: maps[i]['id'],
        programFieldId: maps[i]['programFieldId'],
        subFieldName: maps[i]['subFieldName'],
      );
    });
  }

  Future<List<SubField>> readAllSubFieldList() async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query('subField');

    return List.generate(maps.length, (i) {
      List<String> subItemList = [];
      for (int j = 0; j < 10; j++) {
        subItemList.add(maps[i]['item${j + 1}']);
      }

      return SubField(
        id: maps[i]['id'],
        programFieldId: maps[i]['programFieldId'],
        subFieldName: maps[i]['subFieldName'],
      );
    });
  }

  Future deleteSubField(int id) async {
    final db = await initializeDB();

    await db.delete(
      'subField',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //=======================================================================================
  //                          Firebase 연동 - Test 관련 함수들
  //=======================================================================================

  // Test 추가
  Future<Test> createTest(Test test) async {
    final db = await initializeDB();

    return (await readTest(await db.insert(
      'test',
      test.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )))!;
  }

  // Test 복사
  Future copyTest(Test test) async {
    Test newTest = Test(
      testId: test.testId,
      childId: test.childId,
      title: "${test.title}_복사본",
      date: DateTime.now(),
      isInput: false,
    );
    Test copiedTest = await createTest(newTest);

    List<TestItem> testItemList = [];
    for (TestItem testItem in await readTestItemList(test.testId)) {
      copyTestItem(testItem, copiedTest.testId);
      testItemList.add(testItem);
    }
  }

  // Test 열람
  Future<Test?> readTest(int testId) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'test',
      where: 'id = ?',
      whereArgs: [testId],
    );
    return List.generate(maps.length, (i) {
      return Test(
        testId: maps[i]['id'],
        childId: maps[i]['childId'],
        date: DateTime.parse(maps[i]['date']),
        title: maps[i]['title'],
        isInput: maps[i]['isInput'] == 0 ? false : true,
      );
    })[0];
  }

  Future<List<Test>> readAllTest() async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query('test');

    return List.generate(maps.length, (i) {
      return Test(
        testId: maps[i]['id'],
        childId: maps[i]['childId'],
        date: DateTime.parse(maps[i]['date']),
        title: maps[i]['title'],
        isInput: maps[i]['isInput'] == 0 ? false : true,
      );
    });
  }

  Future<List<Test>> readTestList(int id) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'test',
      where: 'id = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return Test(
        testId: maps[i]['id'],
        childId: maps[i]['childId'],
        date: DateTime.parse(maps[i]['date']),
        title: maps[i]['title'],
        isInput: maps[i]['isInput'] == 0 ? false : true,
      );
    });
  }

  // Test 수정
  Future updateTest(Test test) async {
    final db = await initializeDB();

    await db.update(
      'test',
      test.toMap(),
      // test의 id가 일치하는 지 확인합니다.
      where: "id = ?",
      // test의 id를 whereArg로 넘겨 SQL injection을 방지합니다.
      whereArgs: [test.testId],
    );
  }

  // Test 삭제
  Future deleteTest(int testId) async {
    final db = await initializeDB();

    await db.delete(
      'test',
      where: "id = ?",
      whereArgs: [testId],
    );
  }

  //=======================================================================================
  //                          Firebase 연동 - Test Item 관련 함수들
  //=======================================================================================

  // TestItem 추가
  Future<TestItem?> createTestItem(TestItem testItem) async {
    final db = await initializeDB();

    int testItemId = await db.insert(
      'testItem',
      testItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(await readTestItem(testItemId));
    return await readTestItem(testItemId);
  }

  Future copyTestItem(TestItem testItem, int testId) async {
    TestItem newTestItem = TestItem(
      testItemId: testItem.testItemId,
      testId: testId,
      childId: testItem.childId,
      programField: testItem.programField,
      subField: testItem.subField,
      subItem: testItem.subItem,
    );
    createTestItem(newTestItem);
  }

  // TestItem 열람
  Future<TestItem?> readTestItem(int testItemId) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'testItem',
      where: 'id = ?',
      whereArgs: [testItemId],
    );
    return List.generate(maps.length, (i) {
      return TestItem(
        testItemId: maps[i]['id'],
        testId: maps[i]['testId'],
        childId: maps[i]['childId'],
        programField: maps[i]['programField'],
        subField: maps[i]['subField'],
        subItem: maps[i]['subItem'],
      );
    })[0];
  }

  Future readAllTestItem() async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query('testItem');

    return List.generate(maps.length, (i) {
      return TestItem(
        testItemId: maps[i]['id'],
        testId: maps[i]['testId'],
        childId: maps[i]['childId'],
        programField: maps[i]['programField'],
        subField: maps[i]['subField'],
        subItem: maps[i]['subItem'],
      );
    });
  }

  Future readAllTestItemNotNull() async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'testItem',
      where: 'result = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return TestItem(
        testItemId: maps[i]['id'],
        testId: maps[i]['testId'],
        childId: maps[i]['childId'],
        programField: maps[i]['programField'],
        subField: maps[i]['subField'],
        subItem: maps[i]['subItem'],
      );
    });
  }

  Future<List<TestItem>> readTestItemList(int testId) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'testItem',
      where: 'testId = ?',
      whereArgs: [testId],
    );
    return List.generate(maps.length, (i) {
      return TestItem(
        testItemId: maps[i]['id'],
        testId: maps[i]['testId'],
        childId: maps[i]['childId'],
        programField: maps[i]['programField'],
        subField: maps[i]['subField'],
        subItem: maps[i]['subItem'],
      );
    });
  }

  Future<List<TestItem>> readTestItemListByChild(int id) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'testItem',
      where: 'id = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return TestItem(
        testItemId: maps[i]['id'],
        testId: maps[i]['testId'],
        childId: maps[i]['childId'],
        programField: maps[i]['programField'],
        subField: maps[i]['subField'],
        subItem: maps[i]['subItem'],
      );
    });
  }

  Future<List<TestItem>> readTestItemListBySubField(SubField subField) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'testItem',
      where: 'subField = ?',
      whereArgs: [subField.subFieldName],
    );
    return List.generate(maps.length, (i) {
      return TestItem(
        testItemId: maps[i]['id'],
        testId: maps[i]['testId'],
        childId: maps[i]['childId'],
        programField: maps[i]['programField'],
        subField: maps[i]['subField'],
        subItem: maps[i]['subItem'],
      );
    });
  }

  // TestItem 수정
  Future updateTestItem(int testItemId, String result) async {
    final db = await initializeDB();

    await db.update(
      'testItem',
      {'result': result},
      where: "id = ?",
      whereArgs: [testItemId],
    );
  }

  // Test 삭제
  Future deleteTestItem(int testItemId) async {
    final db = await initializeDB();

    await db.delete(
      'testItem',
      where: "id = ?",
      whereArgs: [testItemId],
    );
  }
}
