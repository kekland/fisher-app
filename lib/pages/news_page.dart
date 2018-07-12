import 'package:fisher/classes/news_data.dart';
import 'package:fisher/classes/user_data.dart';
import 'package:fisher/widgets/news_widget.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

List<NewsData> data = [
  NewsData(
    author: UserData(
      userID: 123,
      name: Name(first: 'FirstName', last: 'LastName'),
    ),
    publishTime: DateTime.now(),
    body:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin est justo, malesuada ut scelerisque sit amet, elementum in nulla. Ut vestibulum quis diam ut laoreet. Integer vitae consequat tortor. Duis mollis lorem est, at lobortis mi egestas suscipit. Nam sit amet nulla lorem. Nunc porttitor purus felis, quis luctus enim sagittis vitae. Sed a purus faucibus nisl dapibus feugiat nec sit amet nulla. Etiam eget sollicitudin tellus, in tristique nisi. Nulla imperdiet ac urna nec accumsan. Nunc sed turpis sit amet lectus faucibus venenatis bibendum vel tellus. Fusce hendrerit pulvinar nibh at hendrerit. Praesent non fermentum ex, maximus tincidunt sem. Integer convallis purus id nulla convallis condimentum. Mauris imperdiet faucibus velit vulputate semper. Pellentesque id congue odio. Cras et urna vel lacus iaculis vulputate et id risus.',
    liked: true,
    likeCount: 100,
  ),
];

class _NewsPageState extends State<NewsPage> {
  onLikeTap(int index) {
    setState(() {
      if (data[index].liked) {
        data[index].likeCount--;
      } else {
        data[index].likeCount++;
      }
      data[index].liked = !data[index].liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return NewsWidget(data[index], () => onLikeTap(index));
      },
      padding: const EdgeInsets.all(8.0),
      itemCount: data.length,
    );
  }
}
