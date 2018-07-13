import 'package:fisher/classes/news_data.dart';
import 'package:fisher/pages/image_carousel_page.dart';
import 'package:fisher/pages/profile_page.dart';
import 'package:fisher/utils.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:geocoder/geocoder.dart';

class NewsWidget extends StatelessWidget {
  final NewsData data;
  final Function onLikeTap;
  NewsWidget(this.data, this.onLikeTap);

  onProfileTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(uuid: data.author.userID)));
  }

  openCarousel(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ImageCarouselNetworkPage(
            urls: data.imageURL,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            leading: InkWell(
              onTap: () => onProfileTap(context),
              child: CircleAvatar(
                child: Text(data.author.name.first.toUpperCase()[0]),
              ),
            ),
            title: Text(
              data.author.name.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            subtitle: Text(
              Utils.dateTimeToString(data.publishTime.toLocal()),
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          InkWell(
            onTap: () => print('text full'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                data.body,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.left(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: (data.imageURL == null)
                    ? []
                    : data.imageURL.map((String url) {
                        return InkWell(
                          onTap: () => openCarousel(context),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              height: 200.0,
                              width: 200.0,
                            ),
                          ),
                        );
                      }).toList(),
              ),
            ),
          ),
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
    );*/



    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => openCarousel(context),
            child: Stack(
              children: <Widget>[
                Image.network(
                  data.imageURL[0],
                  fit: BoxFit.cover,
                  height: 200.0,
                  width: double.infinity,
                ),
                Container(
                  width: double.infinity,
                  height: 200.0,
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withAlpha(100), Colors.transparent],
                      begin: AlignmentDirectional.bottomCenter,
                      end: AlignmentDirectional.topCenter,
                    ),
                  ),
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    data.locationName,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
            child: Text(
              data.body,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
          ListTile(
            dense: true,
            leading: InkWell(
              onTap: () => onProfileTap(context),
              child: CircleAvatar(
                child: Text(data.author.name.first.toUpperCase()[0]),
              ),
            ),
            title: Text(
              data.author.name.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontFamily: 'Futura',
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              Utils.dateTimeToString(data.publishTime.toLocal()),
            ),
            trailing: (data.liked)
                ? IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: onLikeTap,
                  )
                : IconButton(
                    icon: Icon(Icons.favorite_border),
                    color: Colors.black54,
                    onPressed: onLikeTap,
                  ),
          ),
        ],
      ),
    );
  }
}
