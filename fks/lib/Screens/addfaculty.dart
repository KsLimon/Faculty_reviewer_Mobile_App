import 'package:firebase_auth/firebase_auth.dart';
import 'package:fks/Screens/home.dart';
import 'package:fks/Screens/profile.dart';
import 'package:fks/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:fks/components/appback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fks/Screens/evaluate.dart';


import 'login/login.dart';

class AddFaculty extends StatefulWidget {
  const AddFaculty({Key? key, required User user}): _user = user, super(key: key);
  final User _user;
  @override
  _AddFacultyState createState() => _AddFacultyState();
}
class _AddFacultyState extends State<AddFaculty> {
  late User _user;
  late String name, ini, mail, dep, link='';

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

  getname(String name){
    this.name=name;
  }
  getini(String ini){
    this.ini=ini;
  }
  getdep(String dep){
    this.dep=dep;
  }
  getlink(String link){
    this.link=link;
  }

  createaccount(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("Faculty").doc(ini);
    Map<String, dynamic> faculty = {
      "name": name,
      "initial": ini,
      "department": dep,
      "link": link,
      "score": '0',
      "tscore": '0',
      "fscore": '0',
      "gscore": '0',
    };

    documentReference.set(faculty).whenComplete((){
      Navigator.push(context, MaterialPageRoute(builder: (context) => EvalScreen(user: _user, initial: ini,)));
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
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
              PopupMenuItem(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddFaculty(user: _user)));
                  },
                  child: ListTile(
                    leading: Icon(Icons.add_box),
                    title: Text("Add Faculty"),
                  ),
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
            Expanded(
                child: Stack(
                    children: <Widget>[
                      ListView(children: <Widget>[
                        SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Add Faculty",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2661FA),
                    fontSize: 36
                ),
                textAlign: TextAlign.left,
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Name"
                ),
                onChanged: (String name){
                  getname(name);
                  // getmail();
                },
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Initial"
                ),
                onChanged: (String ini){
                  getini(ini);
                },
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Department"
                ),
                onChanged: (String dep){
                  getdep(dep);
                },
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "NSU profile link if any"
                ),
                onChanged: (String link){
                  getlink(link);
                },
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                textColor: Colors.white,
                padding: const EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: new LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 136, 34),
                            Color.fromARGB(255, 255, 177, 41)
                          ]
                      )
                  ),
                  padding: const EdgeInsets.all(0),
                  child: GestureDetector(
                    onTap: () => {
                      createaccount()
                    },
                    child: Text(
                      "SIGN UP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
                      ])])),
          ],
        ),
      ),
    );
  }
}