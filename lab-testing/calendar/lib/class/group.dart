import 'package:calendar/class/user.dart';

class Group {
  String groupId = "";
  String groupName = "";
  String groupCategory = ""; // 청년부, 대학부, 중등부, 고등부, 기독교 동아리, etc...
  List<User> admins = []; 
  List<User> executives = [];
  List<User> member = [];
  // 그룹 일정
}