class Child {
  // Child
  final int childId; // PK
  final String teacherEmail; // FK
  final String name;
  final DateTime birthday;
  final String gender;

  Child({required this.childId, required this.teacherEmail, required this.name, required this.birthday, required this.gender});

  int get age => DateTime.now().year - birthday.year + 1;

  Map<String, dynamic> toMap() {
    return {
      'child-id': childId,
      'teacher-email': teacherEmail,
      'name': name,
      'gender': gender,
      'birthday': birthday
    };
  }
}

