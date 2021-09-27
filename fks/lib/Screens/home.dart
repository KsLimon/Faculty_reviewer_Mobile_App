import 'package:firebase_auth/firebase_auth.dart';
import 'package:fks/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:fks/Screens/login/login.dart';
import 'package:fks/components/appback.dart';
import 'package:fks/Screens/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required User user}): _user = user, super(key: key);
  final User _user;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  late User _user;

  @override
  void click() {
    signOutGoogle();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user: _user)));
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
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20 / 4, // 5 top and bottom
        ),
        decoration: BoxDecoration(
          color: Colors.indigoAccent[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(
            offset: Offset(0, 15),
            blurRadius: 27,
            color: Colors.black26, // Black color with 12% opacity
          )],
        ),
        child: TextField(
          // onChanged: onChanged,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            icon: Icon(Icons.search),
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
            Container(
              height: 136,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.indigoAccent[100],
                  boxShadow: [BoxShadow(
                  offset: Offset(0, 15),
              blurRadius: 27,
              color: Colors.black26, // Black color with 12% opacity
            )],
              ),

              child: Container(
                height: 136,
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                ),
                child: ListTile(
                  leading: Image.asset("assets/images/mam.png"),
                  title: Text(
                      "Faculty Info",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.03),

          ],
        ),
      ),
    );
  }
}
