class Name {
  String first;
  String last;

  toString() {
    return first + ' ' + last;
  }

  Name({this.first, this.last});
}

class UserData {
  int userID;
  Name name;
}
