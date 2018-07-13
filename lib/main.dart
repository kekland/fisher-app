import 'package:fisher/classes/user_data.dart';
import 'package:fisher/onboarding/onboarding_page.dart';
import 'package:fisher/pages/home_page.dart';
import 'package:fisher/pages/login_registration_page.dart';
import 'package:fisher/pages/new_post_page.dart';
import 'package:fisher/pages/profile_page.dart';
import 'package:fisher/pages/login_registration_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialPageRoute.debugEnableFadingRoutes = true;
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: Colors.blue.shade700,
      ),
      home: new OnboardingPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/registration': (context) => LoginRegistrationPage(),
        '/new_post': (context) => NewCatchPage(),
      },
    );
  }
}
