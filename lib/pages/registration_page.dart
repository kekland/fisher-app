import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController nameController;
  TextEditingController cityController;
  GlobalKey<ScaffoldState> scaffold = new GlobalKey();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    cityController = TextEditingController();
  }

  onRegisterTap(BuildContext context) async {
    if (emailController.text.length == 0 || nameController.text.length == 0 || cityController.text.length == 0) {
      scaffold.currentState.showSnackBar(SnackBar(content: Text('All fields must be filled')));
    } else if (passwordController.text.length < 6) {
      scaffold.currentState.showSnackBar(SnackBar(content: Text('Your password is too short')));
    } else {
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
                  Text('Creating account for you'),
                ],
              ),
            );
          });
      try {
        FirebaseUser user = await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        DatabaseReference thisUserReference = database.reference().child('users').child(user.uid);

        await thisUserReference.child('name').set(nameController.text);
        await thisUserReference.child('city').set(cityController.text);
        await thisUserReference.child('email').set(emailController.text);
        await thisUserReference.child('subscribers').child('count').set(1);
        await thisUserReference.child('subscribers').child(user.uid).set(true);
        await thisUserReference.child('subscribed').child('count').set(1);
        await thisUserReference.child('subscribed').child(user.uid).set(true);
        await thisUserReference.child('posts').child('count').set(0);
        await thisUserReference.child('likes').set(0);

        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        scaffold.currentState.showSnackBar(SnackBar(content: Text('Error occurred during registration'), duration: Duration(seconds: 2)));
        Navigator.of(context).pop();
      }
    }
  }

  checkLogin(BuildContext context) async {
    if ((await auth.currentUser()) != null) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  bool checkedLogin = false;
  @override
  Widget build(BuildContext context) {
    if (!checkedLogin) {
      checkLogin(context);
      checkedLogin = true;
    }
    return Scaffold(
      key: scaffold,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal,
              Colors.lightBlue,
            ],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Registration',
                      style: TextStyle(
                        fontSize: 30.0,
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
                    TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        labelText: 'Name',
                      ),
                      controller: nameController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.location_city),
                        labelText: 'City or country',
                      ),
                      controller: cityController,
                    ),
                    SizedBox(height: 24.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton.icon(
                        color: Colors.lightGreen,
                        textColor: Colors.white,
                        onPressed: () => onRegisterTap(context),
                        icon: Icon(Icons.chevron_right),
                        label: Text('Register'),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
