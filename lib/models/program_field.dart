class ProgramField {
  final int id;
  final String title;

  ProgramField({required this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }
}
