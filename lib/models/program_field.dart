import 'package:aba_analysis_local/models/sub_field.dart';

class ProgramField {
  final String title;
  late List<SubField> subFieldList;

  ProgramField({ required this.title, required this.subFieldList });

  void addSubField(SubField subField) {
    subFieldList.add(subField);
  }

  void removeSubField(SubField subField) {
    subFieldList.remove(subField);
  }
}
