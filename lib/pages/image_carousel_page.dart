import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_carousel/image_carousel.dart';

class ImageCarouselPage extends StatefulWidget {
  final List<File> images;
  ImageCarouselPage({this.images});
  @override
  _ImageCarouselPageState createState() => _ImageCarouselPageState();
}

class _ImageCarouselPageState extends State<ImageCarouselPage> {
  back(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
              child: Center(
                child: ImageCarousel(
                  widget.images
                      .map((File image) {
                        return FileImage(image);
                      })
                      .toList()
                      .cast<ImageProvider>(),
                  canCloseZoomOnTap: true,
                  fit: BoxFit.fitWidth,
                  height: double.infinity,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => back(context),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageCarouselNetworkPage extends StatefulWidget {
  final List<String> urls;
  ImageCarouselNetworkPage({this.urls});
  @override
  _ImageCarouselPageNetworkState createState() => _ImageCarouselPageNetworkState();
}

class _ImageCarouselPageNetworkState extends State<ImageCarouselNetworkPage> {
  back(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
              child: Center(
                child: ImageCarousel(
                  widget.urls
                      .map((String url) {
                        return NetworkImage(url);
                      })
                      .toList()
                      .cast<ImageProvider>(),
                  canCloseZoomOnTap: true,
                  fit: BoxFit.fitWidth,
                  height: double.infinity,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => back(context),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
