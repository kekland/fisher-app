class Name {
  String first;
  String last;

  toString() {
    return first + ' ' + last;
  }

  Name({this.first, this.last});
}

class UserData {
  String userID;
  Name name;
  String city;

  UserData({this.userID, this.name, this.city});
}

class UserAdditionalData {
  int postsCount;
  int subscribersCount;
  int likesCount;
  bool isSubscribed;

  UserAdditionalData({this.postsCount, this.subscribersCount, this.likesCount, this.isSubscribed});
}
