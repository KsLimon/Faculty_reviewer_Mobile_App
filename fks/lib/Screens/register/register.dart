import 'package:firebase_auth/firebase_auth.dart';
import 'package:fks/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:fks/components/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key, required User user}): _user = user, super(key: key);
  final User _user;
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  late User _user;
  late String name, id, mail, pass;

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  getname(String name){
    this.name=name;
  }
  getid(String id){
    this.id=id;
  }
  getmail(){
    this.mail= _user.email!;
  }
  getpass(String pass){
    this.pass=pass;
  }

  createaccount(){
    print("I will create account");

    DocumentReference documentReference = FirebaseFirestore.instance.collection("User").doc(mail);
    Map<String, dynamic> users = {
      "name": name,
      "id": id,
      "mail": mail,
      "Dep": pass
  };

    documentReference.set(users).whenComplete((){
      print("$name created");
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user: _user)));
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
                "Create Your Account",
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
                  getmail();
                },
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Student ID"
                ),
                onChanged: (String id){
                  getid(id);
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
                onChanged: (String pass){
                  getpass(pass);
                },
              ),
            ),

            SizedBox(height: size.height * 0.05),

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
          ],
        ),
      ),
    );
  }
}