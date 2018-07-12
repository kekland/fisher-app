import 'package:fisher/classes/user_data.dart';
import 'package:fisher/pages/home_page.dart';
import 'package:fisher/pages/new_post_page.dart';
import 'package:fisher/pages/profile_page.dart';
import 'package:fisher/pages/registration_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialPageRoute.debugEnableFadingRoutes = true;
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: new RegistrationPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/registration': (context) => RegistrationPage(),
        '/new_post': (context) => NewPostPage(),
      },
    );
  }
}
