import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fks/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:fks/Screens/login/login.dart';
import 'package:fks/components/appback.dart';
import 'package:fks/Screens/profile.dart';
import 'package:fks/Screens/Rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fks/Screens/addfaculty.dart';

import 'home.dart';

class NScreen extends StatefulWidget {
  const NScreen({Key? key, required User user}): _user = user, super(key: key);
  final User _user;
  @override
  _NScreenState createState() => _NScreenState();
}
class _NScreenState extends State<NScreen> {
  late User user;

  @override
  void click() {
    signOutGoogle();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    user = widget._user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: user,)));
                  },
                  child: ListTile(
                    leading: Image.network(
                      user.photoURL!,
                      fit: BoxFit.fitHeight,
                    ),
                    title: Text(user.displayName!),
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddFaculty(user: user)));
                  },
                  child: ListTile(
                    leading: Icon(Icons.add_box),
                    title: Text("Add Faculty"),
                  ),
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
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Notification').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((document) {
                          return Container(
                            height: 136,
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.indigoAccent[100],
                              boxShadow: [BoxShadow(
                                offset: Offset(0, 15),
                                blurRadius: 27,
                                color: Colors
                                    .black26, // Black color with 12% opacity
                              )
                              ],
                            ),
                            child: Container(
                                height: 136,
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),

                                child: new Column(
                                  children: [
                                    new ListTile(
                                      title: Text(
                                        "${document["user"]} Added:\n${document["initial"]}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children:<Widget>[
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              DocumentReference documentReference = FirebaseFirestore.instance.collection("Notification").doc(document["initial"]);
                                              documentReference.delete();
                                              DocumentReference df = FirebaseFirestore.instance.collection("Faculty").doc(document["initial"]);
                                              df.delete();

                                            });
                                          },

                                        child: Container(
                                          height: 30,
                                          width: 85,
                                          margin: const EdgeInsets.only(left: 50, top: 20, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                            ),
                                            color: Colors.indigoAccent[100],
                                          ),
                                          child: Text(
                                            "Delete",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              DocumentReference documentReference = FirebaseFirestore.instance.collection("Notification").doc(document["initial"]);
                                              documentReference.delete();
                                            });
                                          },
                                        child: Container(
                                          height: 30,
                                          width: 85,
                                          margin: const EdgeInsets.only(left: 60, top: 20, right: 40),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                            ),
                                            color: Colors.cyan[300],
                                          ),
                                          child: Text(
                                            "Aprove",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.03),

          ],
        ),
      ),
    );
  }
}