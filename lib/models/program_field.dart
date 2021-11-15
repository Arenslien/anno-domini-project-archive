import 'package:aba_analysis_local/models/sub_field.dart';

class ProgramField {
  final int id;
  final String title;

  ProgramField({ required this.id, required this.title });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}
