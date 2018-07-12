import 'package:fisher/classes/user_data.dart';

class NewsData {
  UserData author;

  String body;
  List<String> imageURL;

  NewsData({this.author, this.body, this.imageURL});
}
