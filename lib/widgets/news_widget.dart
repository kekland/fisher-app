import 'package:fisher/classes/news_data.dart';
import 'package:fisher/pages/profile_page.dart';
import 'package:fisher/utils.dart';
import 'package:flutter/material.dart';

class NewsWidget extends StatelessWidget {
  final NewsData data;
  final Function onLikeTap;
  NewsWidget(this.data, this.onLikeTap);

  onProfileTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ProfilePage(userData: data.author))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => onProfileTap(context),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(data.author.name.first.toUpperCase()[0]),
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.author.name.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        Utils.dateTimeToString(data.publishTime.toLocal()),
                        style: TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1.0),
          InkWell(
            onTap: () => print('text full'),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                data.body,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Divider(height: 1.0),
          InkWell(
            onTap: onLikeTap,
            highlightColor: (data.liked) ? null : Colors.red.withAlpha(50),
            splashColor: (data.liked) ? null : Colors.red.withAlpha(25),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 6.0, top: 12.0, bottom: 12.0),
                      child: (data.liked)
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(Icons.favorite_border),
                    ),
                    Text(data.likeCount.toString()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
