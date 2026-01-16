import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/models/sub_item.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  // Firebase DB 컬렉션
  CollectionReference _user = FirebaseFirestore.instance.collection('User');
  CollectionReference _child = FirebaseFirestore.instance.collection('Child');
  CollectionReference _test = FirebaseFirestore.instance.collection('Test');
  CollectionReference _testItem =
      FirebaseFirestore.instance.collection('Test Item');
  CollectionReference _programField =
      FirebaseFirestore.instance.collection('Program Field');
  CollectionReference _subField =
      FirebaseFirestore.instance.collection('Sub Field');
  CollectionReference _subItem =
      FirebaseFirestore.instance.collection('Sub Item');
  CollectionReference _childResult =
      FirebaseFirestore.instance.collection('Child Result');
  CollectionReference _autoId =
      FirebaseFirestore.instance.collection('Auto ID');

  //=======================================================================================
  //                          Firebase 연동 - 사용자 관련 함수들
  //=======================================================================================

  // 사용자 생성
  Future createUser(ABAUser abaUser) async {
    // Firestore에 사용자 문서 추가
    return await _user
        .doc(abaUser.email)
        .set(abaUser.toMap())
        .then((value) => print('[사용자: ${abaUser.email}}] - 추가 완료'))
        .catchError((error) =>
            print('[사용자: ${abaUser.email}}] - 추가 실패\n에러 내용: $error'));
  }

  // 사용자 읽기
  Future<ABAUser?> readUser(String email) async {
    // 해당 이메일에 대한 User 정보 가져오기
    dynamic data = await _user
        .doc(email)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
    if (data == null) return null;

    // User 정보를 기반으로 ABAUser 인스턴스 생성
    ABAUser abaUser = ABAUser(
      email: data['email'],
      password: data['password'],
      nickname: data['nickname'],
      duty: data['duty'],
      approvalStatus: data['approval-status'],
      deleteRequest: data['delete-request'],
    );

    // ABAUser 반환
    return abaUser;
  }

  // 미승인 사용자 읽기
  Future<List<ABAUser>> readUnapprovedUser() async {
    List<ABAUser> unapprovedUserList = [];

    // 모든 아이들 데이터 가져오기
    await _user
        .where('approval-status', isEqualTo: false)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((document) {
              dynamic data = document.data();
              ABAUser abaUser = ABAUser(
                email: data['email'],
                password: data['password'],
                nickname: data['nickname'],
                duty: data['duty'],
                approvalStatus: data['approval-status'],
                deleteRequest: data['delete-request'],
              );
              unapprovedUserList.add(abaUser);
            }));

    return unapprovedUserList;
  }

  // 승인된 사용자 읽기
  Future<List<ABAUser>> readApprovedUser() async {
    List<ABAUser> approvedUserList = [];

    // 모든 아이들 데이터 가져오기
    await _user
        .where('approval-status', isEqualTo: true)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((document) {
              dynamic data = document.data();
              ABAUser abaUser = ABAUser(
                email: data['email'],
                password: data['password'],
                nickname: data['nickname'],
                duty: data['duty'],
                approvalStatus: data['approval-status'],
                deleteRequest: data['delete-request'],
              );
              approvedUserList.add(abaUser);
            }));

    return approvedUserList;
  }

  // 사용자 수정
  Future updateUser(String email, String nickname, String duty,
      bool approvalStatus, bool deleteRequest) async {
    return _user
        .doc(email)
        .update({
          'nickname': nickname,
          'duty': duty,
          'approval-status': approvalStatus,
          'delete-request': deleteRequest,
        })
        .then((value) => print('[사용자: $email] - 수정 완료'))
        .catchError((error) => print('[사용자: $email] - 수정 실패\n에러 내용: $error'));
  }

  // 사용자 삭제
  Future deleteUser(String email) async {
    return await _user
        .doc(email)
        .delete()
        .then((value) => print('[사용자: $email] - 삭제 완료'))
        .catchError((error) => print('[사용자: $email] - 삭제 실패\n에러 내용: $error'));
  }

  Future<bool> checkUserWithEmail(String email) async {
    try {
      QueryDocumentSnapshot abaUser = await _user
          .where('email', isEqualTo: email)
          .get()
          .then((snapshot) => snapshot.docs[0]);
      return abaUser.exists;
    } catch (e) {
      print('해당 이메일을 지닌 유저가 없음');
      return false;
    }
  }

  //=======================================================================================
  //                          Firebase 연동 - 아이들 관련 함수들
  //=======================================================================================

  Future createChild(Child child) {
    // 데이터베이스에 Child 문서 추가
    return _child
        .doc(child.childId.toString())
        .set(child.toMap())
        .then((value) => print('[아동: ${child.name}] - 추가 완료'))
        .catchError(
            (error) => print('[아동: ${child.name}] - 추가 실패\n에러 내용: $error'));
  }

  // 교사가 맡고 있는 모든 아이들 데이터 가져오기
  Future<List<Child>> readAllChild(String email) async {
    // Child List 초기화 & 선언
    List<Child> children = [];

    // 모든 아이들 데이터 가져오기
    await _child
        .where('teacher-email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((document) {
              dynamic data = document.data();
              Timestamp date = data['birthday'];
              Child child = Child(
                  childId: data['child-id'],
                  teacherEmail: data['teacher-email'],
                  name: data['name'],
                  birthday: date.toDate(),
                  gender: data['gender']);
              children.add(child);
            }));

    // 이름 순으로 list 정렬
    children.sort((a, b) => a.name.compareTo(b.name));

    return children;
  }

  Future<Child?> readChild(int childId) async {
    // 해당 이메일에 대한 Child 정보 가져오기
    dynamic data = await _child
        .doc(childId.toString())
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
    if (data == null) return null;

    Timestamp date = data['birthday'];

    // Child 정보를 기반으로 Child 인스턴스 생성
    Child child = Child(
        childId: data['child-id'],
        teacherEmail: data['teacher-email'],
        name: data['name'],
        birthday: date.toDate(),
        gender: data['gender']);

    // Child 반환
    return child;
  }

  Future updateChild(
      int childId, String name, DateTime birthday, String gender) async {
    // 해당 아이의 Document 업데이트 -> 사전에 변경될 name, birthday, gender 값이 필수로 꼭 필요! 변경이 없다면 기존의 값을 그대로 넣어야 함
    await _child
        .doc(childId.toString())
        .update({
          'name': name,
          'birthday': birthday,
          'gender': gender,
        })
        .then((value) => print('[아동: $name] - 추가 완료'))
        .catchError((error) => print('[아동: $name] - 추가 실패\n에러 내용: $error'));
  }

  Future deleteChild(int childId) async {
    await _child
        .doc(childId.toString())
        .delete()
        .then((value) => print('[아동: $childId] - 추가 완료'))
        .catchError((error) => print('[아동: $childId] - 추가 실패\n에러 내용: $error'));
  }

  //=======================================================================================
  //                          Firebase 연동 - 하위 영역 관련 함수들
  //=======================================================================================

  Future addProgramField(String title) async {
    int id = await updateId(AutoID.programField);
    ProgramField programField = new ProgramField(id: id, title: title);

    // 변경된 새로운 programField 추가
    _programField
        .doc(id.toString())
        .set(programField.toMap())
        .then((value) => print("프로그램 영역이 추가 되었습니다."))
        .catchError((error) => print("프로그램 영역 추가를 실패했습니다. : $error"));
  }

  Future deleteProgramField(int id) async {
    await _programField
        .doc(id.toString())
        .delete()
        .then((value) => print('프로그램 영역 삭제 완료'))
        .catchError((error) => print('프로그램 영역 삭제 실패\n에러 내용: $error'));
  }

  Future<List<ProgramField>> readAllProgramField() async {
    List<ProgramField> programFieldList = [];
    // 모든 프로그램 영역 가져오기
    await _programField
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((element) {
              dynamic data = element.data();
              ProgramField programField =
                  ProgramField(id: data['id'], title: data['title']);
              programFieldList.add(programField);
            }))
        .catchError((error) => print('모든 프로그램 영역 가져오기 실패\n에러 내용: $error'));
    return programFieldList;
  }

  Future addSubField(SubField subField) async {
    // 새로운 Sub Field 추가
    await _subField
        .doc(subField.id.toString())
        .set(subField.toMap())
        .then((value) => print("하위 영역이 추가 되었습니다."))
        .catchError((error) => print("하위 영역 추가를 실패했습니다. : $error"));
  }

  Future deleteSubField(int id) async {
    // SubField 삭제
    await _subField
        .doc(id.toString())
        .delete()
        .then((value) => print('하위 영역 삭제 완료'))
        .catchError((error) => print('하위 영역 삭제 실패\n에러 내용: $error'));
  }

  Future<List<SubField>> readAllSubField() async {
    List<SubField> subFieldList = [];
    // 모든 프로그램 영역 가져오기
    await _subField
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((element) {
              dynamic data = element.data();
              SubField subField = SubField(
                  id: data['id'],
                  programFieldId: data['programFieldId'],
                  subFieldName: data['subFieldName']);
              subFieldList.add(subField);
            }))
        .catchError((error) => print('모든 프로그램 영역 가져오기 실패\n에러 내용: $error'));
    return subFieldList;
  }

  Future addSubItem(SubItem subItem) async {
    // 새로운 Sub Item 추가
    await _subItem
        .doc(subItem.id.toString())
        .set(subItem.toMap())
        .then((value) => print("하위 목록이 추가 되었습니다."))
        .catchError((error) => print("하위 목록 추가를 실패했습니다. : $error"));
  }

  Future deleteSubItem(int index) async {
    // SubItem 삭제
    await _subItem
        .doc(index.toString())
        .delete()
        .then((value) => print('하위 목록 삭제 완료'))
        .catchError((error) => print('하위 목록 삭제 실패\n에러 내용: $error'));
  }

  Future<List<SubItem>> readAllSubItem() async {
    List<SubItem> subItemList = [];

    List<QueryDocumentSnapshot> docs =
        await _subItem.get().then((QuerySnapshot snapshot) => snapshot.docs);

    for (QueryDocumentSnapshot doc in docs) {
      List<String> subItems = [];
      dynamic data = doc.data();

      for (int i = 0; i < 10; i++) {
        subItems.add(data['item${i + 1}']);
      }
      SubItem subField = SubItem(
          id: data['id'],
          subFieldId: data['subFieldId'],
          subItemList: subItems);
      subItemList.add(subField);
    }

    return subItemList;
  }

  Future<SubItem> readSubItem(int subFieldId) async {
    List<String> subItems = [];
    SubItem? subItem;
    List<QueryDocumentSnapshot> docs =
        await _subItem.get().then((QuerySnapshot snapshot) => snapshot.docs);

    for (QueryDocumentSnapshot doc in docs) {
      dynamic data = doc.data();

      if (data['subFieldId'] == subFieldId) {
        subItem = SubItem(
            id: data['id'],
            subFieldId: data['subFieldId'],
            subItemList: subItems);
        break;
      }
    }

    return subItem!;
  }

  //=======================================================================================
  //                          Firebase 연동 - Test 관련 함수들
  //=======================================================================================

  // Test 추가
  Future createTest(Test test) async {
    // 데이터베이스에 Test 문서 추가
    return await _test
        .doc(test.testId.toString())
        .set(test.toMap())
        .then((value) => print(' 테스트가 성공적으로 추가되었습니다.'))
        .catchError((error) => print('테스트를 추가하지 못했습니다.\n에러 내용: $error'));
  }

  // Test 복사
  Future<Test> copyTest(Test test) async {
    Test copiedTest = Test(
        testId: await updateId(AutoID.test),
        childId: test.childId,
        date: DateTime.now(),
        title: '${test.title} 복사본',
        isInput: false,
        memo: "");
    await _test
        .doc(copiedTest.testId.toString())
        .set(copiedTest.toMap())
        .then((value) => print(' 테스트가 성공적으로 복사되었습니다.'))
        .catchError((error) => print('테스트를 복사하지 못했습니다.\n에러 내용: $error'));
    return copiedTest;
  }

  // Test 열람
  Future<Test?> readTest(int testId) async {
    // 해당 testId에 대한 Document 정보 가져오기
    dynamic data = await _test
        .doc(testId.toString())
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
    if (data == null) return null;

    // Document data 기반 Test 객체 생성
    Test test = Test(
        testId: data['test-id'],
        childId: data['child-id'],
        date: data['date'],
        title: data['title'],
        isInput: data['is-input'],
        memo: data['memo']);

    // Test 반환
    return test;
  }

  Future<List<Test>> readAllTest() async {
    List<Test> allTestList = [];

    List<QueryDocumentSnapshot> docs =
        await _test.get().then((QuerySnapshot snapshot) => snapshot.docs);

    for (QueryDocumentSnapshot doc in docs) {
      dynamic data = doc.data();
      Timestamp date = data['date'];

      // 테스트 생성 & 추가
      Test test = Test(
          testId: data['test-id'],
          childId: data['child-id'],
          date: date.toDate(),
          title: data['title'],
          isInput: data['is-input'],
          memo: data['memo']);
      allTestList.add(test);
    }

    return allTestList;
  }

  Future<List<Test>> readTestList(int childId) async {
    List<Test> testList = [];
    // 해당 childId에 대한
    List<QueryDocumentSnapshot> docs = await _test
        .where('child-id', isEqualTo: childId)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs);

    // 각각의 문서를 Test 인스턴스로 변환 후 추가
    for (QueryDocumentSnapshot doc in docs) {
      dynamic data = doc.data();
      Timestamp date = data['date'];

      // Test 생성 & 추가
      Test test = Test(
          testId: data['test-id'],
          childId: data['child-id'],
          date: date.toDate(),
          title: data['title'],
          isInput: data['is-input'],
          memo: data['memo']);
      testList.add(test);
    }

    return testList;
  }

  // Test 수정
  Future updateTest(
      int testId, DateTime date, String title, bool isInput, String memo) async {
    // 해당 Test의 Document 업데이트 -> 사전에 변경될 date, title 값이 필수로 꼭 필요! 변경이 없다면 기존의 값을 그대로 넣어야 함
    await _test
        .doc(testId.toString())
        .update({
          'date': date,
          'title': title,
          'is-input': isInput,
          'memo': memo,
        })
        .then((value) => print("[ID: $testId]의 테스트가 업데이트 되었습니다."))
        .catchError(
            (error) => print("[ID: $testId]의 테스트 정보 업데이트를 실패했습니다. : $error"));
  }

  // Test 삭제
  Future deleteTest(int testId) async {
    await _test
        .doc(testId.toString())
        .delete()
        .then((value) => print("테스트가 삭제되었습니다."))
        .catchError((error) => "테스트를 삭제하지 못했습니다. : $error");
  }

  //=======================================================================================
  //                          Firebase 연동 - Test Item 관련 함수들
  //=======================================================================================

  // TestItem 추가
  Future createTestItem(TestItem testItem) async {
    // 데이터베이스에 Test 문서 추가
    return await _testItem
        .doc(testItem.testItemId.toString())
        .set(testItem.toMap())
        .then((value) => print('테스트가 성공적으로 추가되었습니다.'))
        .catchError((error) => print('테스트를 추가하지 못했습니다.\n에러 내용: $error'));
  }

  Future<TestItem> copyTestItem(
      int testId, int childId, TestItem testItem) async {
    TestItem copiedTestItem = TestItem(
      testItemId: await updateId(AutoID.testItem),
      testId: testId,
      childId: childId,
      programField: testItem.programField,
      subField: testItem.subField,
      subItem: testItem.subItem,
    );
    await _testItem
        .doc(copiedTestItem.testItemId.toString())
        .set(copiedTestItem.toMap())
        .then((value) => print(' 테스트아이템이 성공적으로 복사되었습니다.'))
        .catchError((error) => print('테스트아이템을 복사하지 못했습니다.\n에러 내용: $error'));
    return copiedTestItem;
  }

  // TestItem 열람
  Future<TestItem?> readTestItem(int index) async {
    // 해당 testItemId에 대한 Document 정보 가져오기
    dynamic data = await _testItem
        .doc(index.toString())
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
    if (data == null) return null;

    // Document data 기반 TestItem 객체 생성
    TestItem testItem = TestItem(
      testItemId: data['test-item-id'],
      testId: data['test-id'],
      childId: data['child-id'],
      programField: data['program-field'],
      subField: data['sub-field'],
      subItem: data['sub-item'],
    );
    testItem.setP(data['p']);
    testItem.setP(data['plus']);
    testItem.setP(data['minus']);

    // TestItem 반환
    return testItem;
  }

  Future readAllTestItem() async {
    List<TestItem> testItemList = [];

    List<QueryDocumentSnapshot> docs =
        await _testItem.get().then((QuerySnapshot snapshot) => snapshot.docs);

    for (QueryDocumentSnapshot doc in docs) {
      // doc의 데이터 가져오기
      dynamic data = doc.data();

      // Test Item 문서의 데이터를 기반으로 TestItem 객체 생성
      TestItem testItem = TestItem(
        testItemId: data['test-item-id'],
        testId: data['test-id'],
        childId: data['child-id'],
        programField: data['program-field'],
        subField: data['sub-field'],
        subItem: data['sub-item'],
      );
      testItem.setP(data['p']);
      testItem.setPlus(data['plus']);
      testItem.setMinus(data['minus']);

      // TestItemList에 TestItem 객체 추가
      testItemList.add(testItem);
    }

    // 테스트 아이템 리스트 반환
    return testItemList;
  }

  // TestItem 수정
  Future updateTestItem(TestItem testItem) async {
    // 해당 Test의 Document 업데이트 -> 사전에 변경될 date, title, testItemList 값이 필수로 꼭 필요! 변경이 없다면 기존의 값을 그대로 넣어야 함
    await _testItem
        .doc(testItem.testItemId.toString())
        .update({
          'p': testItem.p,
          'plus': testItem.plus,
          'minus': testItem.minus,
        })
        .then((value) =>
            print("[테스트 아이템: ${testItem.testItemId}]의 테스트 아이템이 업데이트 되었습니다."))
        .catchError((error) => print(
            "[테스트 아이템: ${testItem.testItemId}]의 테스트 아이템 업데이트를 실패했습니다. : $error"));
  }

  // Test 삭제
  Future deleteTestItem(int testItemId) async {
    await _testItem
        .doc(testItemId.toString())
        .delete()
        .then((value) => print("테스트 아이템이 삭제되었습니다."))
        .catchError((error) => "테스트 아이템을 삭제하지 못했습니다. : $error");
  }

  //=======================================================================================
  //                          Firebase 연동 - AutoID 관련 함수들
  //=======================================================================================

  Future<dynamic> readAutoIDDocumentData() async {
    // Auto ID 컬렉션의 AutoID 문서의 데이터를 가져옴
    return _autoId
        .doc('AutoID')
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
  }

  Future<int> readId(AutoID autoID) async {
    // Auto ID 문서의 데이터 가져오기
    dynamic data = await readAutoIDDocumentData();

    // 데이터의 필드값 중 child-id의 값 가져오기
    int autoId;
    switch (autoID) {
      case AutoID.child:
        autoId = data['child-id'];
        break;
      case AutoID.test:
        autoId = data['test-id'];
        break;
      case AutoID.testItem:
        autoId = data['test-item-id'];
        break;
      case AutoID.programField:
        autoId = data['program-field-id'];
        break;
      case AutoID.subField:
        autoId = data['sub-field-id'];
        break;
      case AutoID.subItem:
        autoId = data['sub-item-id'];
        break;
      case AutoID.childResult:
        autoId = data['child-result-id'];
        break;
    }

    // autoId 반환
    return autoId;
  }

  Future<int> updateId(AutoID autoID) async {
    // id 값 읽어오기
    int id = await readId(autoID);

    // id 값 업데이트
    switch (autoID) {
      case AutoID.child:
        _autoId.doc('AutoID').update({'child-id': id + 1});
        break;
      case AutoID.test:
        _autoId.doc('AutoID').update({'test-id': id + 1});
        break;
      case AutoID.testItem:
        _autoId.doc('AutoID').update({'test-item-id': id + 1});
        break;
      case AutoID.programField:
        _autoId.doc('AutoID').update({'program-field-id': id + 1});
        break;
      case AutoID.subField:
        _autoId.doc('AutoID').update({'sub-field-id': id + 1});
        break;
      case AutoID.subItem:
        _autoId.doc('AutoID').update({'sub-item-id': id + 1});
        break;
      case AutoID.childResult:
        _autoId.doc('AutoID').update({'child-result-id': id + 1});
        break;
    }

    // update 된 ID 값 반환
    return id + 1;
  }
}
