import 'package:aba_analysis_local/models/aba_user.dart';
import 'package:flutter/foundation.dart';

class UserNotifier extends ChangeNotifier {

  ABAUser? _abaUser;

  List<ABAUser> _unapprovedUsers = [];
  List<ABAUser> _approvedUsers = [];

  void updateUser(ABAUser? abaUser) {
    _abaUser = abaUser;
    notifyListeners();
  }

  void updateUnapprovedUsers(List<ABAUser> unapprovedUserList) {
    _unapprovedUsers = unapprovedUserList;
    notifyListeners();
  }

  void deleteUnapprovedUser(String email) {
    for (int i=0; i<_unapprovedUsers.length; i++) {
      if (_unapprovedUsers[i].email == email) {
        _unapprovedUsers.removeAt(i);
      }
    }
    notifyListeners();
  }

  void updateApprovedUsers(List<ABAUser> approvedUserList) {
    _approvedUsers = approvedUserList;
    notifyListeners();
  }

  void updateApprovedUser(int index) {
    _approvedUsers[index].deleteRequest = false;
    notifyListeners();
  }

  void deleteApprovedUser(String email) {
    for (int i=0; i<_approvedUsers.length; i++) {
      if (_approvedUsers[i].email == email) {
        _approvedUsers.removeAt(i);
      }
    }
    notifyListeners();
  }

  List<ABAUser> get unapprovedUsers => _unapprovedUsers;
  List<ABAUser> get approvedUsers => _approvedUsers;

  ABAUser? get abaUser => _abaUser;
}