import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fisher/classes/news_data.dart';
import 'package:fisher/classes/user_data.dart';
import 'package:fisher/widgets/news_widget.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

List<NewsData> news = [];

class _NewsPageState extends State<NewsPage> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<Null> fetchData() async {
    final FirebaseUser user = await auth.currentUser();

    DatabaseReference subscribedToList = database.reference().child('users/${user.uid}/subscribed');
    final subscriptionSnapshot = await subscribedToList.once();

    Map data = subscriptionSnapshot.value;
    List uidList = [];
    data.keys.forEach((key) {
      if (key != 'count') {
        uidList.add(key);
      }
    });

    List<NewsData> newsData = [];
    for (String uid in uidList) {
      DatabaseReference postReference = database.reference().child('/users/$uid/posts');
      Map receivedNewsData = (await postReference.limitToFirst(10).once()).value;

      DatabaseReference userReference = database.reference().child('/users/$uid');
      String city = (await userReference.child('city').once()).value;
      String name = (await userReference.child('name').once()).value;
      receivedNewsData.forEach((id, data) {
        if (id != 'count') {
          var liked_by = data['liked_by'];
          newsData.add(
            new NewsData(
              author: UserData(userID: uid, city: city, name: Name(first: name, last: '')),
              body: data['body'],
              postID: id,
              publishTime: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
              likeCount: (liked_by != null) ? (liked_by as Map).keys.length : 0,
              liked: (liked_by != null) ? (liked_by as Map).containsKey(user.uid) : false,
            ),
          );
        }
      });
    }

    setState(() {
      news.clear();
      newsData.forEach((d) {
        news.add(d);
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchData,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: NewsWidget(news[index], () => onLikeTap(index)),
          );
        },
        padding: const EdgeInsets.all(8.0),
        itemCount: news.length,
      ),
    );
  }
}
