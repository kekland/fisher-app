import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fisher/classes/news_data.dart';
import 'package:fisher/classes/user_data.dart';
import 'package:fisher/widgets/counter_widget.dart';
import 'package:fisher/widgets/news_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';

class ProfilePage extends StatefulWidget {
  final String uuid;
  //final UserData userData;
  ProfilePage({this.uuid});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

List<NewsData> news = [];

class _ProfilePageState extends State<ProfilePage> {
  UserData userData;
  UserAdditionalData additionalData;
  bool isHimself = false;

  bool loading = true;
  bool error = false;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Null> fetchAdditionalUserDetails() async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
          error = false;
        });
      }
      final FirebaseUser user = await auth.currentUser();
      String uid = widget.uuid;

      DatabaseReference thisUserReference = database.reference().child('users/$uid');

      String name = ((await thisUserReference.child('name').once()).value);
      String city = ((await thisUserReference.child('city').once()).value);
      int postCount = ((await thisUserReference.child('posts').once()).value as Map).length - 1;
      int subscribedCount = ((await thisUserReference.child('subscribed').once()).value as Map).length - 2;
      int subscribersCount = ((await thisUserReference.child('subscribers').once()).value as Map).length - 2;
      bool isSubscribed = ((await thisUserReference.child('subscribers').once()).value as Map).containsKey(user.uid);

      isHimself = user.uid == uid;

      if (mounted) {
        setState(() {
          loading = false;
          error = false;
          userData = new UserData(
            userID: uid,
            name: Name(first: name, last: ''),
            city: city,
          );
          additionalData = new UserAdditionalData(
            postsCount: postCount,
            subscribedCount: subscribedCount,
            subscribersCount: subscribersCount,
            isSubscribed: isSubscribed,
          );
          fetchData();
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  Future<Null> fetchData() async {
    try {
      final FirebaseUser user = await auth.currentUser();

      DatabaseReference subscribedToList = database.reference().child('users/${user.uid}/subscribed');
      String uid = user.uid;

      List<NewsData> newsData = [];

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
          if (addresses.length == 0) {
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
      setState(() {
        news.clear();
        newsData.forEach((d) {
          news.add(d);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  initState() {
    super.initState();
    fetchAdditionalUserDetails();
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

  onSubscribeTap() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: (!loading && !error)
          ? RefreshIndicator(
              onRefresh: fetchData,
              child: ListView.builder(
                itemCount: news.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        margin: EdgeInsets.zero,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 16.0),
                            CircleAvatar(
                              child: Text(userData.name.first.toUpperCase()[0]),
                              radius: 48.0,
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      userData.name.toString(),
                                      style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      (userData.city != null) ? userData.city : 'Unknown',
                                      style: TextStyle(
                                        color: Colors.black38,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    (additionalData != null)
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      child: RaisedButton.icon(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                                        icon: Icon(
                                          ((additionalData.isSubscribed) ? Icons.check : Icons.add),
                                        ),
                                        label: Text(
                                          ((additionalData.isSubscribed) ? 'Subscribed' : 'Subscribe'),
                                        ),
                                        onPressed: (isHimself) ? null : onSubscribeTap,
                                      ),
                                    ),
                                  ],
                                ),
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
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              ),
            )
          : (error)
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        iconSize: 36.0,
                        icon: Icon(Icons.refresh),
                        onPressed: fetchAdditionalUserDetails,
                      ),
                      Text(
                        'Something went wrong. Click button above to refresh',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
