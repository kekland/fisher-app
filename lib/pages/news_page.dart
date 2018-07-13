import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fisher/classes/news_data.dart';
import 'package:fisher/classes/user_data.dart';
import 'package:fisher/widgets/news_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

List<NewsData> news = [];

class _NewsPageState extends State<NewsPage> with SingleTickerProviderStateMixin {
  bool loading = false;
  bool error = false;
  bool displayedBefore = false;
  Animation<double> animation;
  AnimationController controller;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<Null> fetchData() async {
    try {
      final FirebaseUser user = await auth.currentUser();
      if (mounted) {
        setState(() {
          loading = true;
          error = false;
        });
      }

      DatabaseReference subscribedToList = database.reference().child('users');
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

        for (int i = 0; i < receivedNewsData.length; i++) {
          dynamic id = receivedNewsData.keys.elementAt(i);
          dynamic data = receivedNewsData.values.elementAt(i);
          if (id != 'count') {
            var liked_by = data['liked_by'];
            var images = data['images'];
            final Coordinates coords = new Coordinates(data['latitude'], data['longitude']);
            var addresses = await Geocoder.local.findAddressesFromCoordinates(coords);
            var address;
            if (addresses.isEmpty) {
              address = 'Unknown location';
            } else {
              address = addresses.first.adminArea + ', ' + addresses.first.countryName;
            }
            newsData.add(
              new NewsData(
                author: UserData(userID: uid, city: city, name: Name(first: name, last: '')),
                body: data['body'],
                imageURL: (images == null) ? null : (images as Map).values.toList().cast<String>(),
                postID: id,
                publishTime: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
                likeCount: (liked_by != null) ? (liked_by as Map).keys.length : 0,
                liked: (liked_by != null) ? (liked_by as Map).containsKey(user.uid) : false,
                latitude: data['latitude'],
                longitude: data['longitude'],
                locationName: address,
              ),
            );
          }
        }
      }

      if (mounted) {
        setState(() {
          news.clear();
          newsData.forEach((d) {
            news.add(d);
          });
          loading = false;
          error = false;
          displayedBefore = true;
          controller.forward(from: 0.0);
        });
      }
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          error = true;
          loading = false;
          controller.forward(from: 0.0);
        });
      }
    }
  }

  initState() {
    super.initState();
    fetchData();
    controller = new AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });
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
    if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    if (loading && !displayedBefore) {
      return Center(child: CircularProgressIndicator());
    } else if (error) {
      return Opacity(
        opacity: animation.value,
        child: new Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                iconSize: 36.0,
                icon: Icon(Icons.refresh),
                onPressed: fetchData,
              ),
              Text(
                'Something went wrong. Click button above to refresh',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      );
    } else {
      return Opacity(
        opacity: animation.value,
        child: RefreshIndicator(
          onRefresh: fetchData,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: NewsWidget(news[index], () => onLikeTap(index)),
              );
            },
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            itemCount: news.length,
          ),
        ),
      );
    }
  }
}
