import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/program_field.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
import 'package:aba_analysis_local/models/sub_item.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

class DBService {
  Future<Database> initializeDB() async {
    var databasesPath = await getDatabasesPath();
    String path = Path.join(databasesPath, 'aba_analysis.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        print("start");
        await db.execute("CREATE TABLE child(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, birthday TEXT, gender TEXT)");
        await db.execute("CREATE TABLE test(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, childId INTEGER, date TEXT, title TEXT, isInput INTEGER, memo TEXT)");
        await db.execute("CREATE TABLE testItem(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, testId INTEGER, childId INTEGER, programField TEXT, subField TEXT, subItem TEXT, p INTEGER, plus INTEGER, minus INTEGER)");
        await db.execute("CREATE TABLE programField(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT)");
        await db.execute("CREATE TABLE subField(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, programFieldId INTEGER NOT NULL)");
        await db.execute("CREATE TABLE subItem(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, subFieldId INTEGER NOT NULL, item1 TEXT, item2 TEXT, item3 TEXT, item4 TEXT, item5 TEXT, item6 TEXT, item7 TEXT, item8 TEXT, item9 TEXT, item10 TEXT)");
        await db.execute("CREATE TABLE initStatus(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, status INTEGER)");
        await db.rawInsert("INSERT INTO initStatus(status) VALUES(?)", [0]);
        dynamic initStatus = await db.query(
          'initStatus',
          where: 'id = ?',
          whereArgs: [1],
        );
        if (initStatus[0]['status'] == 0) {
          await db.update(
            'initStatus',
            {'status': 1},
            // Dog의 id가 일치하는 지 확인합니다.
            where: "id = ?",
            // Dog의 id를 whereArg로 넘겨 SQL injection을 방지합니다.
            whereArgs: [1],
          );

          for (int i = 0; i < 9; i++) {
            await db.rawInsert('INSERT INTO programField(title) VALUES(?)',
                [basicProgramField[i]]);
            await db.rawInsert(
                'INSERT INTO subField(title, programFieldId) VALUES(?, ?)',
                [basicSubField[i], (i + 1)]);
            await db.rawInsert(
                'INSERT INTO subItem(subFieldId, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                [
                  (i+1),
                  basicSubItem[i][0],
                  basicSubItem[i][1],
                  basicSubItem[i][2],
                  basicSubItem[i][3],
                  basicSubItem[i][4],
                  basicSubItem[i][5],
                  basicSubItem[i][6],
                  basicSubItem[i][7],
                  basicSubItem[i][8],
                  basicSubItem[i][9]
                ]);
          }
        }

        print("end");
      },
      version: 1,
    );
  }

  Future<void> deleteDB() async {
    await deleteDatabase(
        Path.join(await getDatabasesPath(), 'aba_analysis.db'));
    print('delete');
  }
  //=======================================================================================
  //                          Firebase 연동 - 아이들 관련 함수들
  //=======================================================================================

  Future<void> createChild(Child child) async {
    final db = await initializeDB();
    await db.rawInsert('INSERT INTO child(name, birthday, gender) VALUES(?, ?, ?)', [child.name, DateFormat('yyyy-MM-dd').format(child.birthday), child.gender]);
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
  //                          Firebase 연동 - 프로그램 영역 관련 함수들
  //=======================================================================================
  Future<void> createInitProgramField() async {
    
  }



  Future<void> createProgramField(String title) async {
    final db = await initializeDB();
    await db.rawInsert('INSERT INTO programField(title) VALUES(?)', [title]);
  }

  // 교사가 맡고 있는 모든 아이들 데이터 가져오기
  Future<List<ProgramField>> readAllProgramField() async {
    // 모든 Child 얻기 위해 테이블에 질의합니다.
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('programField');
    return queryResult.map((e) => ProgramField.fromMap(e)).toList();
  }

  Future<ProgramField?> readProgramField(int id) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'programField',
      where: 'id = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return ProgramField(
        id: maps[i]['id'],
        title: maps[i]['title'],
      );
    })[0];
  }

  Future deleteProgramField(int id) async {
    final db = await initializeDB();

    await db.delete(
      'programField',
      // 특정 dog를 제거하기 위해 `where` 절을 사용하세요
      where: "id = ?",
      // Dog의 id를 where의 인자로 넘겨 SQL injection을 방지합니다.
      whereArgs: [id],
    );
  }

  //=======================================================================================
  //                          Firebase 연동 - 서브 영역 관련 함수들
  //=======================================================================================

  Future<int> addSubField(SubField subField) async {
    final db = await initializeDB();
    return await db.rawInsert('INSERT INTO subField(title, programFieldId) VALUES(?, ?)', [subField.title, subField.programFieldId]);
  }

  Future<List<SubField>> readSubFieldList(int id) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'subField',
      where: "programFieldId = ?",
      whereArgs: [id],
    );

    return List.generate(maps.length, (i) {
      return SubField(
        id: maps[i]['id'],
        programFieldId: maps[i]['programFieldId'],
        title: maps[i]['title'],
      );
    });
  }

  Future<List<SubField>> readAllSubFieldList() async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query('subField');

    return List.generate(maps.length, (i) {
      return SubField(
        id: maps[i]['id'],
        programFieldId: maps[i]['programFieldId'],
        title: maps[i]['title'],
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
  //                          Firebase 연동 - 서브 아이템 관련 함수들
  //=======================================================================================

  Future<int> addSubItem(SubItem subItem) async {
    final db = await initializeDB();
    return await db.rawInsert('INSERT INTO subItem(subFieldId, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [subItem.subFieldId, subItem.subItemList[0], subItem.subItemList[1], subItem.subItemList[2], subItem.subItemList[3], subItem.subItemList[4], subItem.subItemList[5], subItem.subItemList[6], subItem.subItemList[7], subItem.subItemList[8], subItem.subItemList[9]]);
  }

  Future<SubItem> readSubItem(int id) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'subItem',
      where: "id = ?",
      whereArgs: [id],
    );

    return List.generate(maps.length, (i) {
      List<String> subItemList = [];
      for (int j = 0; j < 10; j++) {
        subItemList.add(maps[i]['item${j + 1}']);
      }

      return SubItem(
        id: maps[i]['id'],
        subFieldId: maps[i]['subFieldId'],
        subItemList: subItemList,
      );
    })[0];
  }

  Future<List<SubItem>> readAllSubItemList() async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> maps = await db.query('subItem');

    return List.generate(maps.length, (i) {
      List<String> subItemList = [];
      for (int j = 0; j < 10; j++) {
        subItemList.add(maps[i]['item${j + 1}']);
      }

      return SubItem(
        id: maps[i]['id'],
        subFieldId: maps[i]['subFieldId'],
        subItemList: subItemList,
      );
    });
  }

  Future deleteSubItem(int id) async {
    final db = await initializeDB();

    await db.delete(
      'subItem',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //=======================================================================================
  //                          Firebase 연동 - Test 관련 함수들
  //=======================================================================================

  // Test 추가
  Future<int> createTest(Test test) async {
    final db = await initializeDB();

    return await db.rawInsert('INSERT INTO test(childId, date, title, isInput, memo) VALUES(?, ?, ?, ?, ?)', [test.childId, DateFormat('yyyy-MM-dd').format(test.date), test.title, test.isInput ? 1 : 0, test.memo]);
  }

  // childId INTEGER, date TEXT, title TEXT, isInput INTEGER)

  // Test 복사
  Future copyTest(Test test) async {
    Test newTest = Test(
      testId: 0,
      childId: test.childId,
      title: "${test.title}_복사본",
      date: DateTime.now(),
      isInput: false,
      memo: "",
    );

    Test copiedTest = (await readTest(await createTest(newTest)))!;

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
        memo: maps[i]['memo'],
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
        memo: maps[i]['memo'],
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
        memo: maps[i]['memo'],
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
  Future<int> createTestItem(TestItem testItem) async {
    final db = await initializeDB();
    return await db.rawInsert('INSERT INTO testItem(testId, childId, programField, subField, subItem, p, plus, minus) VALUES(?, ?, ?, ?, ?, ?, ?, ?)', [testItem.testId, testItem.childId, testItem.programField, testItem.subField, testItem.subItem, testItem.p, testItem.plus, testItem.minus]);
  }

  Future copyTestItem(TestItem testItem, int testId) async {
    TestItem newTestItem = TestItem(
      testItemId: 0,
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
      TestItem testItem = TestItem(
        testItemId: maps[i]['id'],
        testId: maps[i]['testId'],
        childId: maps[i]['childId'],
        programField: maps[i]['programField'],
        subField: maps[i]['subField'],
        subItem: maps[i]['subItem'],
      );
      testItem.setP(maps[i]['p']);
      testItem.setPlus(maps[i]['plus']);
      testItem.setMinus(maps[i]['minus']);
      return testItem;
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
      whereArgs: [subField.title],
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
  Future updateTestItem(int testItemId, int plus, int minus, int p) async {
    final db = await initializeDB();

    await db.update(
      'testItem',
      {'plus': plus, 'minus': minus, 'p': p},
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
