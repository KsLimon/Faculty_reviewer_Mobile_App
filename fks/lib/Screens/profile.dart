import 'package:firebase_auth/firebase_auth.dart';
import 'package:fks/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:fks/Screens/login/login.dart';
import 'package:fks/components/appback.dart';
import 'package:fks/Screens/home.dart';
import 'package:fks/Screens/evaluate.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required User user}): _user = user, super(key: key);
  final User _user;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  void click() {
    signOutGoogle();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: _user,)));
                  },
                  child: ListTile(
                    leading: Image.network(
                      _user.photoURL!,
                      fit: BoxFit.fitHeight,
                    ),
                    title: Text(_user.displayName!),
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user: _user,)));
                  },
                  child: ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                  ),
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.anchor),
                  title: Text('Item 2'),
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.article),
                  title: Text('Item 3'),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: this.click,
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(
                      "SIGN OUT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.indigoAccent,
      ),
      body: Appback(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 130),
              child: Image.network(
                  _user.photoURL!,
                ),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Text(
                _user.displayName!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2661FA),
                    fontSize: 20
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Text(
                _user.email!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 17
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
