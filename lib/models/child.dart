class Child {
  // Child
  int? id; // PK
  final String name;
  final DateTime birthday;
  final String gender;

  Child({this.id, required this.name, required this.birthday, required this.gender});

  int get age => DateTime.now().year - birthday.year + 1;

  Map<String, dynamic> toMap() {
    return {'name': name, 'gender': gender, 'birthday': birthday.toString()};
  }
}
