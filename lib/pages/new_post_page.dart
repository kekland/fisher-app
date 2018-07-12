import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  Text('Publishing your cool post :P'),
                ],
              ),
            );
          });
      try {
        FirebaseDatabase database = FirebaseDatabase.instance;
        FirebaseAuth auth = FirebaseAuth.instance;
        String uid = (await auth.currentUser()).uid;
        DatabaseReference newsReference = database.reference().child('users/$uid/posts').push();
        DatabaseReference newsCountReference = database.reference().child('users/$uid/posts/count');

        await newsReference.child('body').set(bodyController.text);
        await newsReference.child('likes').set(1);
        await newsReference.child('liked_by').child(uid).set(true);

        await newsCountReference.runTransaction((MutableData a) async {
          await newsCountReference.set(a.value + 1);
        });

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } catch (e) {
        scaffold.currentState.showSnackBar(SnackBar(content: Text('Error occurred during registration'), duration: Duration(seconds: 2)));
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: Text('Add new post'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => send(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'What\'s new?',
                  border: InputBorder.none,
                ),
                controller: bodyController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
