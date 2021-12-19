class ChildSubItem {
  final int childId; // PK
  final int subItemId; // PK
  final int p;
  final int plus;
  final int minus;

  ChildSubItem({required this.p, required this.plus, required this.minus, required this.childId, required this.subItemId});

  // DB -> 넘김
  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'subItemId': subItemId,
      'p': p,
      'plus': plus,
      'minus': minus,
    };
  }
}