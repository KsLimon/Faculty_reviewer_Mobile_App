import 'dart:ui';
import 'package:alert/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fks/Screens/register/register.dart';
import 'package:fks/components/background.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fks/components/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  late User user;
  static late String eml;

  @override
  void initState() {
    super.initState();
    signOutGoogle();
  }

  void click() {
    signInWithGoogle().then((user) => {
      this.user = user!,
      _LoginScreenState.eml = user.email!,
      if(!user.email!.endsWith('@northsouth.edu')){
        Alert(message: 'Use NSU mail account for SignUp').show(),
        Phoenix.rebirth(context)
      },
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => RegisterScreen()))
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Welcome, To Faculty Reviewer App",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2661FA),
                  fontSize: 36
                ),
                textAlign: TextAlign.left,
              ),
            ),

            SizedBox(height: size.height * 0.05),

            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 90),
              child: Image.asset(
                  "assets/images/main.png",
                  width: size.width * 0.80
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 65, vertical: 10),

              child: OutlinedButton(
                  onPressed: this.click,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(image: AssetImage('assets/images/google_logo.png'), height: 30),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('Sign Up With Google',
                                  style: TextStyle(color: Colors.indigoAccent, fontSize: 20)))
                        ],
                      ))
              ),
            )
          ],
        ),
      ),
    );
  }
}

class getml{
  static String mm = _LoginScreenState.eml;
}