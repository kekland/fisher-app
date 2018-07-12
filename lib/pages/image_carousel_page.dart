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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: ImageCarousel(
          widget.images.map((File image) {
            return Image.file(image);
          }).toList().cast<ImageProvider>(),
          allowZoom: true,
        ),
      ),
    );
  }
}
