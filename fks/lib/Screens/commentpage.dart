import 'package:alert/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fks/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:fks/Screens/login/login.dart';
import 'package:fks/components/appback.dart';
import 'package:fks/Screens/profile.dart';
import 'package:fks/Screens/Rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CmntScreen extends StatefulWidget {
  const CmntScreen({Key? key, required String initial,}):_initial=initial, super(key: key);
  final String _initial;
  @override
  _CmntScreenState createState() => _CmntScreenState();
}
class _CmntScreenState extends State<CmntScreen> {
  late String initial;

  TextEditingController textEditingControllero = TextEditingController();

  @override
  void click() {
    signOutGoogle();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    initial = widget._initial;
    super.initState();
  }

  createcmnt(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("Comments").doc();
    String s;
    if (textEditingControllero.text==''){
      Alert(message: 'Add Comment First').show();
      return ;
    }
    else{s=textEditingControllero.text;}
    Map<String, dynamic> cm = {
      "comment": s,
      "cmentor": "Ks Limon",
      "faculty": initial,
    };
    documentReference.set(cm).whenComplete((){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          CmntScreen(
            initial: initial,
          ),
      ));
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Appback(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.01),
            Container(
              margin: EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(
                  offset: Offset(0, 15),
                  blurRadius: 27,
                  color: Colors.black26, // Black color with 12% opacity
                )],
              ),
              child: ListTile(
                title: TextField(
                  controller: textEditingControllero,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Add Comment",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                trailing: GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      createcmnt(),
                  ));},
                    child: const Icon(Icons.send)),
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Comments').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((document) {
                          if(document['faculty']!=initial){
                            return Container();
                          }
                          return Container(
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [BoxShadow(
                                offset: Offset(0, 15),
                                blurRadius: 27,
                                color: Colors.black26, // Black color with 12% opacity
                              )],
                            ),

                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "${document["cmentor"]}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        ),
                                      subtitle: Text(
                                        "${document['comment']}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}