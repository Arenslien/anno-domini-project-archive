class BasicLocation {
  double x, y; //latitude & longitude

  BasicLocation(double x, double y) {
    this.x = x; this.y = y;
  }
}



class UserLocation extends BasicLocation{
  String user_name = "";

  UserLocation(double x, double y) : super(x, y);
}


class BibleVerseLocation extends BasicLocation {
  String bibleVerse = "";
  String producer = "";

  BibleVerseLocation(double x, double y) : super(x, y);
}