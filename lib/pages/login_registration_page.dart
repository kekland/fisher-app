import 'package:fisher/pages/login_card.dart';
import 'package:fisher/pages/registration_card.dart';
import 'package:flutter/material.dart';

class LoginRegistrationPage extends StatefulWidget {
  @override
  _LoginRegistrationPageState createState() => _LoginRegistrationPageState();
}

class _LoginRegistrationPageState extends State<LoginRegistrationPage> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  bool loginVisible = true;

  initState() {
    super.initState();
    controller = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      setState(() {});
    });
  }

  onTap() {
    if (loginVisible) {
      controller.forward(from: 0.0);
    } else {
      controller.reverse(from: 1.0);
    }
    setState(() {
      loginVisible = !loginVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    var stackInner = [
      Transform(
        transform: new Matrix4.translationValues(0.0, 100.0 * animation.value, 0.0),
        child: Opacity(
          opacity: 1.0 - animation.value,
          child: LoginCard(),
        ),
      ),
      Transform(
        transform: new Matrix4.translationValues(0.0, 100.0 * (1.0 - animation.value), 0.0),
        child: Opacity(
          opacity: animation.value,
          child: RegistrationCard(),
        ),
      ),
      Align(
        alignment: AlignmentDirectional.topEnd,
        child: Opacity(
          opacity: 1.0 - animation.value,
          child: FlatButton.icon(
            icon: Icon(Icons.chevron_right),
            label: Text('Register'),
            onPressed: onTap,
            textColor: Colors.white,
          ),
        ),
      ),
      Align(
        alignment: AlignmentDirectional.topStart,
        child: Opacity(
          opacity: animation.value,
          child: FlatButton.icon(
            icon: Icon(Icons.chevron_left),
            label: Text('Login'),
            onPressed: onTap,
            textColor: Colors.white,
          ),
        ),
      ),
    ];
    if (loginVisible) {
      stackInner = stackInner.reversed.toList();
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(Colors.lightBlue, Colors.lime, animation.value),
              Color.lerp(Colors.indigo, Colors.green, animation.value),
            ],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: stackInner,
            ),
          ),
        ),
      ),
    );
  }
}
