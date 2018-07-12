import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  onRegisterTap() {
    final FirebaseAuth auth = FirebaseAuth.instance;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.location_city),
                        labelText: 'City or country',
                      ),
                    ),
                    SizedBox(height: 24.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton.icon(
                        color: Colors.lightGreen,
                        textColor: Colors.white,
                        onPressed: () {},
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
