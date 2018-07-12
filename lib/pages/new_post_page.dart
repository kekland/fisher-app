import 'dart:io';

import 'package:fisher/pages/image_carousel_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  TextEditingController bodyController;
  GlobalKey<ScaffoldState> scaffold;

  initState() {
    super.initState();
    bodyController = new TextEditingController();
  }

  send(BuildContext context) async {
    if (bodyController.text.length != 0) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Please, wait'),
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 24.0),
                  Text('Publishing your cool post'),
                ],
              ),
            );
          });
      try {
        FirebaseDatabase database = FirebaseDatabase.instance;
        FirebaseStorage storage = FirebaseStorage.instance;
        FirebaseAuth auth = FirebaseAuth.instance;
        String uid = (await auth.currentUser()).uid;
        DatabaseReference newsReference = database.reference().child('users/$uid/posts').push();
        DatabaseReference newsCountReference = database.reference().child('users/$uid/posts/count');

        if (images.length > 0) {
          for (File image in images) {
            UploadTaskSnapshot snapshot = await storage.ref().child('images').putFile(image).future;
            await newsReference.push().set(snapshot.downloadUrl.toString());
          }
        }

        await newsReference.child('body').set(bodyController.text);
        await newsReference.child('likes').set(1);
        await newsReference.child('liked_by').child(uid).set(true);
        await newsReference.child('timestamp').set(DateTime.now().millisecondsSinceEpoch);

        await newsCountReference.runTransaction((MutableData a) async {
          await newsCountReference.set(a.value + 1);
        });

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } catch (e) {
        scaffold.currentState.showSnackBar(SnackBar(content: Text('Error occurred during posting'), duration: Duration(seconds: 2)));
        Navigator.of(context).pop();
      }
    } else {}
  }

  List<File> images = [];
  openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image != null && mounted) {
      setState(() {
        images.add(image);
      });
    }
  }

  openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      setState(() {
        images.add(image);
      });
    }
  }

  openCarousel(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ImageCarouselPage(
            images: images,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: Text('Add new post'),
        actions: [
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: (images.length < 3) ? openCamera : null,
          ),
          IconButton(
            icon: Icon(Icons.image),
            onPressed: (images.length < 3) ? openGallery : null,
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => send(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'What\'s new?',
              border: InputBorder.none,
            ),
            controller: bodyController,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: images.map((File image) {
                return InkWell(
                  onTap: () => openCarousel(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Image.file(image, height: 200.0),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class NewCatchPage extends StatefulWidget {
  @override
  _NewCatchPageState createState() => _NewCatchPageState();
}

class _NewCatchPageState extends State<NewCatchPage> {
  TextEditingController bodyController;
  TextEditingController fishController;
  GlobalKey<ScaffoldState> scaffold;

  initState() {
    super.initState();
    bodyController = new TextEditingController();
    fishController = new TextEditingController();
    getLatLong();
  }

  send(BuildContext context) async {
    if (bodyController.text.length != 0) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Please, wait'),
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 24.0),
                  Text('Publishing your cool post'),
                ],
              ),
            );
          });
      try {
        FirebaseDatabase database = FirebaseDatabase.instance;
        FirebaseStorage storage = FirebaseStorage.instance;
        FirebaseAuth auth = FirebaseAuth.instance;
        String uid = (await auth.currentUser()).uid;
        DatabaseReference newsReference = database.reference().child('users/$uid/posts').push();
        DatabaseReference newsCountReference = database.reference().child('users/$uid/posts/count');

        DatabaseReference fishBucketReference = database.reference().child('fish_bucket').push();

        if (images.length > 0) {
          for (File image in images) {
            UploadTaskSnapshot snapshot = await storage.ref().child('images').putFile(image).future;
            await newsReference.push().set(snapshot.downloadUrl.toString());
          }
        }

        await newsReference.child('body').set(bodyController.text);
        await newsReference.child('likes').set(1);
        await newsReference.child('liked_by').child(uid).set(true);
        await newsReference.child('timestamp').set(DateTime.now().millisecondsSinceEpoch);
        await fishBucketReference.child('type').set(fishController.text);
        await fishBucketReference.child('latitude').set(lat);
        await fishBucketReference.child('longitude').set(long);

        await newsCountReference.runTransaction((MutableData a) async {
          await newsCountReference.set(a.value + 1);
        });

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } catch (e) {
        scaffold.currentState.showSnackBar(SnackBar(content: Text('Error occurred during posting'), duration: Duration(seconds: 2)));
        Navigator.of(context).pop();
      }
    } else {}
  }

  List<File> images = [];
  openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image != null && mounted) {
      setState(() {
        images.add(image);
      });
    }
  }

  openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      setState(() {
        images.add(image);
      });
    }
  }

  double lat, long;

  getLatLong() async {
    var currentLocation = <String, double>{};

    var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation;
      setState(() {
        lat = currentLocation['latitude'];
        long = currentLocation['longitude'];
        print(lat);
      });
    } catch (e) {
      currentLocation = null;
    }
  }

  openCarousel(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ImageCarouselPage(
            images: images,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: Text('Add new post'),
        actions: [
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: (images.length < 3) ? openCamera : null,
          ),
          IconButton(
            icon: Icon(Icons.image),
            onPressed: (images.length < 3) ? openGallery : null,
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: (lat != null) ? () => send(context) : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: 'What type of fish is this?',
                  icon: Icon(Icons.select_all),
                  border: OutlineInputBorder(),
                ),
                controller: fishController,
              ),
              SizedBox(height: 12.0),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Your comment',
                  icon: Icon(Icons.comment),
                  border: OutlineInputBorder(),
                ),
                controller: bodyController,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: images.map((File image) {
                return InkWell(
                  onTap: () => openCarousel(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Image.file(image, height: 200.0),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
