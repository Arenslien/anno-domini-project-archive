import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/program_field.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:aba_analysis_local/services/db.dart';
import 'package:flutter/foundation.dart';

class DBNotifier extends ChangeNotifier {

  DBService _db = DBService();

  List<Child> _children = [];
  List<Test> _testList = [];
  List<TestItem> _testItemList = [];
  List<SubField> _subFieldList = [];

  Future initDB() async {
    await _db.initDatabase();

    _children = await _db.readAllChild();
    _testList = await _db.readAllTest();
    _testItemList = await _db.readAllTestItem();
    _subFieldList = await _db.readAllSubFieldList();

    notifyListeners();
  }

  DBService? get database => _db;
  List<Child> get children => _children;
  List<Test> get testList => _testList;
  List<TestItem> get testItemList => _testItemList;
  List<SubField> get subFieldList => _subFieldList;

}