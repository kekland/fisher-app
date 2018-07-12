import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fisher/classes/news_data.dart';
import 'package:fisher/classes/user_data.dart';
import 'package:fisher/widgets/counter_widget.dart';
import 'package:fisher/widgets/news_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final UserData userData;
  ProfilePage({this.userData});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

List<NewsData> news = [];

class _ProfilePageState extends State<ProfilePage> {
  UserAdditionalData additionalData = null;
  bool isHimself = false;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Null> fetchAdditionalUserDetails() async {
    final FirebaseUser user = await auth.currentUser();
    String uid = widget.userData.userID;

    DatabaseReference thisUserReference = database.reference().child('users/$uid');

    int postCount = ((await thisUserReference.child('posts').once()).value as Map).length - 1;
    int subscribedCount = ((await thisUserReference.child('subscribed').once()).value as Map).length - 2;
    int subscribersCount = ((await thisUserReference.child('subscribers').once()).value as Map).length - 2;
    bool isSubscribed = ((await thisUserReference.child('subscribers').once()).value as Map).containsKey(user.uid);

    isHimself = user.uid == uid;

    if (mounted) {
      setState(() {
        additionalData = new UserAdditionalData(
          postsCount: postCount,
          subscribedCount: subscribedCount,
          subscribersCount: subscribersCount,
          isSubscribed: isSubscribed,
        );
      });
    }
  }

  Future<Null> fetchData() async {
    fetchAdditionalUserDetails();
    final FirebaseUser user = await auth.currentUser();
    List<NewsData> newsData = [];
    String uid = widget.userData.userID;
    DatabaseReference postReference = database.reference().child('/users/$uid/posts');
    Map receivedNewsData = (await postReference.limitToFirst(10).once()).value;
    receivedNewsData.forEach((id, data) {
      if (id != 'count') {
        var liked_by = data['liked_by'];
        newsData.add(
          new NewsData(
            author: widget.userData,
            body: data['body'],
            postID: id,
            publishTime: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
            likeCount: (liked_by != null) ? (liked_by as Map).length : 0,
            liked: (liked_by != null) ? (liked_by as Map).containsKey(user.uid) : false,
          ),
        );
      }
    });

    if (mounted) {
      setState(() {
        news.clear();
        newsData.forEach((d) {
          news.add(d);
        });
      });
    }
  }

  initState() {
    super.initState();
    fetchData();
  }

  changeLikeStatusInDatabase(int index) async {
    try {
      DatabaseReference post = database.reference().child('users/${news[index].author.userID}/posts/${news[index].postID}');
      String uid = (await auth.currentUser()).uid;
      if (news[index].liked) {
        await post.child('liked_by/$uid').set(true);
      } else {
        await post.child('liked_by/$uid').remove();
      }
    } catch (e) {
      onLikeTap(index, false);
    }
  }

  onLikeTap(int index, [bool changeDB = true]) {
    setState(() {
      if (news[index].liked) {
        news[index].likeCount--;
      } else {
        news[index].likeCount++;
      }
      news[index].liked = !news[index].liked;
      if (changeDB) {
        changeLikeStatusInDatabase(index);
      }
    });
  }

  onSubscribeTap() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
          itemCount: news.length + 1,
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
                            child: Text(widget.userData.name.first.toUpperCase()[0]),
                          ),
                          SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.userData.name.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                (widget.userData.city != null) ? widget.userData.city : 'Unknown',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      (additionalData != null)
                          ? Row(
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
                                    amount: additionalData.subscribedCount,
                                    description: 'Subscribed to',
                                    accentColor: Colors.redAccent,
                                    primaryColor: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          : CircularProgressIndicator(),
                      SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton.icon(
                          icon: Icon(
                            (additionalData != null) ? ((additionalData.isSubscribed) ? Icons.check : Icons.add) : Icons.refresh,
                          ),
                          label: Text(
                            (additionalData != null) ? ((additionalData.isSubscribed) ? 'Subscribed' : 'Subscribe') : 'Loading',
                          ),
                          onPressed: (isHimself || additionalData == null) ? null : onSubscribeTap,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: NewsWidget(news[index - 1], () => onLikeTap(index - 1)),
              );
            }
          },
          padding: const EdgeInsets.all(8.0),
        ),
      ),
    );
  }
}
