import 'package:fisher/classes/news_data.dart';
import 'package:fisher/classes/user_data.dart';
import 'package:fisher/widgets/counter_widget.dart';
import 'package:fisher/widgets/news_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final UserData data;
  ProfilePage({this.data});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserAdditionalData additionalData = new UserAdditionalData(
    postsCount: 13,
    subscribersCount: 25,
    likesCount: 13,
    isSubscribed: true,
  );
  List<NewsData> posts = [];

  onSubscribeTap() {
    setState(() {
      if (additionalData.isSubscribed) {
        additionalData.subscribersCount--;
      } else {
        additionalData.subscribersCount++;
      }
      additionalData.isSubscribed = !additionalData.isSubscribed;
    });
  }

  onLikeTap(int index) {
    setState(() {
      if (posts[index].liked) {
        posts[index].likeCount--;
      } else {
        posts[index].likeCount++;
      }
      posts[index].liked = !posts[index].liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView.builder(
        itemCount: posts.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        CircleAvatar(
                          child: Text(widget.data.name.first.toUpperCase()[0]),
                        ),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.data.name.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              (widget.data.city != null) ? widget.data : 'Unknown',
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: CounterWidget(
                            amount: additionalData.postsCount,
                            description: 'Posts',
                            accentColor: Colors.orangeAccent,
                            primaryColor: Colors.orange,
                          ),
                        ),
                        Center(
                          child: CounterWidget(
                            amount: additionalData.subscribersCount,
                            description: 'Subscribers',
                            accentColor: Colors.greenAccent,
                            primaryColor: Colors.green,
                          ),
                        ),
                        Center(
                          child: CounterWidget(
                            amount: additionalData.likesCount,
                            description: 'Likes',
                            accentColor: Colors.redAccent,
                            primaryColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: FlatButton.icon(
                        icon: Icon(
                          (additionalData.isSubscribed) ? Icons.check : Icons.add,
                        ),
                        label: Text(
                          (additionalData.isSubscribed) ? 'Subscribed' : 'Subscribe',
                        ),
                        onPressed: onSubscribeTap,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return NewsWidget(posts[index - 1], () => onLikeTap(index - 1));
          }
        },
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }
}
