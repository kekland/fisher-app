import 'package:fisher/classes/user_data.dart';

class NewsData {
  UserData author;
  DateTime publishTime;

  String body;
  String postID;
  List<String> imageURL;

  bool liked;
  int likeCount;

  double latitude;
  double longitude;
  String locationName;

  NewsData({
    this.author,
    this.postID,
    this.body,
    this.imageURL,
    this.publishTime,
    this.liked,
    this.likeCount,
    this.latitude,
    this.longitude,
    this.locationName,
  });
}
