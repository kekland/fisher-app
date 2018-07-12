import 'package:fisher/classes/user_data.dart';

class NewsData {
  UserData author;
  DateTime publishTime;

  String body;
  List<String> imageURL;

  bool liked;
  int likeCount;

  NewsData({
    this.author,
    this.body,
    this.imageURL,
    this.publishTime,
    this.liked,
    this.likeCount,
  });
}
