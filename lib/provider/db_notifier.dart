import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class DBNotifier extends ChangeNotifier {
  late Database _db;

  void initDatabase(Database db) {
    this._db = db;
    notifyListeners();
  }

  // GETTER FUNCTION: db 제공
  Database get db => _db;
}
