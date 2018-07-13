import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  TextEditingController emailController;
  TextEditingController passwordController;
  GlobalKey<ScaffoldState> scaffold = new GlobalKey();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  onLoginTap(BuildContext context) async {
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
                Text('Logging in'),
              ],
            ),
          );
        });
    try {
      FirebaseUser user = await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message), duration: Duration(seconds: 2)));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'E-Mail',
                ),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                controller: passwordController,
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: RaisedButton.icon(
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  onPressed: () => onLoginTap(context),
                  icon: Icon(Icons.chevron_right),
                  label: Text('Login'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
