class ABAUser {
  // ABA User
  final String email;
  final String? password;
  final String nickname;
  final bool approvalStatus;
  String duty;
  bool deleteRequest;

  ABAUser(
      {required this.email,
      required this.password,
      required this.nickname,
      required this.duty,
      required this.approvalStatus,
      required this.deleteRequest});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'nickname': nickname,
      'duty': duty,
      'approval-status': approvalStatus,
      'delete-request': deleteRequest,
    };
  }
}
