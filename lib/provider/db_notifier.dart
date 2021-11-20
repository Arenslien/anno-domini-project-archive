import 'package:aba_analysis_local/services/db.dart';
import 'package:flutter/foundation.dart';

class DBNotifier extends ChangeNotifier {

  DBService _db = DBService();

  Future initDB() async {
    await _db.initDatabase();
      notifyListeners();
    }

  DBService? get database => _db;
}