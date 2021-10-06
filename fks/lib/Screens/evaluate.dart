import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fks/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:fks/Screens/login/login.dart';
import 'package:fks/Screens/home.dart';
import 'package:fks/components/appback.dart';
import 'package:fks/Screens/profile.dart';

import 'Rating.dart';
import 'addfaculty.dart';

class EvalScreen extends StatefulWidget {
  const EvalScreen({Key? key, required User user,required String initial,}): _user = user,_initial=initial, super(key: key);
  final User _user;
  final String _initial;
  @override
  _EvalScreenState createState() => _EvalScreenState();
}
class _EvalScreenState extends State<EvalScreen> {
  late User _user;
  late String initial;
  List<CheckBoxListTileModel> checkBoxListTileModel =
  CheckBoxListTileModel.getUsers();
  double ts=0, fs=0, gs=0;

  @override
  void initState() {
    _user = widget._user;
    initial = widget._initial;
    super.initState();
  }

  @override
  void click() {
    signOutGoogle();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  // readdata(){
  //   DocumentReference documentReference= FirebaseFirestore.instance.collection('Faculty').doc(initial);
  //   String oname, oini, odep, olink, oos, ots, ofs, ogs;
  //   documentReference.get().then((value){
  //     oname = value.data["name"];
  //     oini = value.data().
  //   });
  // }

  dataload() async {
    var collection = FirebaseFirestore.instance.collection('Faculty').doc(initial);
    var querySnapshot = await collection.get();
    Map<String, dynamic>? data = querySnapshot.data();
    String score = data!['score'];
    String facini = data['initial'];
    String fname = data['name'];
    String fdep = data['department'];
    String flink = data['link'];
    String tscore = data['tscore'];
    String fscore = data['fscore'];
    String gscore = data['gscore'];

    double nos, nts, nfs, ngs;
    if (score == '0'){
      nts=ts;
      nfs=fs;
      ngs=gs;
      nos=((ts+fs+gs)*10)/30;
    }
    else{
      double os = double.parse(score);
      double ots = double.parse(tscore);
      double ofs = double.parse(fscore);
      double ogs = double.parse(gscore);
      nts = ((ts+ots)*10)/20;
      nfs = ((fs+ofs)*10)/20;
      ngs = ((gs+ogs)*10)/20;
      double result= ((nts+nfs+ngs)*10)/30;

      nos=((os+result)*10)/20;
    }

    Map<String, dynamic> faculty = {
      "name": fname,
      "initial": facini,
      "department": fdep,
      "link": flink,
      'score': nos.toString(),
      'tscore': nts.toString(),
      'fscore': nfs.toString(),
      'gscore': ngs.toString(),
    };

    collection.set(faculty).whenComplete(() => {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          RateScreen(
            user: _user,
            initial: facini,
            name: fname,
            department: fdep,
            link: flink,
            score: nos.toString(),
            tscore: nts.toString(),
            fscore: nfs.toString(),
            gscore: ngs.toString(),
          )))
    },);
  }

  void itemChange(bool val, int index) {
    setState(() {
      checkBoxListTileModel[index].isCheck = val;
      if(index<=4){
        if (val==true){
          ts=ts+2;
        }
        else{
          ts=ts-2;
        }
      }
      else if(index>=5 && index<=9){
        if (val==true){
          fs=fs+2;
        }
        else{
          fs=fs-2;
        }
      }
      else{
        if (val==true){
          gs=gs+2;
        }
        else{
          gs=gs-2;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluate Your Faculty'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry>[
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: _user,)));
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
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomeScreen(user: _user)));
                  },
                  child: ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                  ),
                ),
              ),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => AddFaculty(user: _user)));
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
        ListView.builder(
            itemCount: checkBoxListTileModel.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                child:
                new Container(
                  // padding: new EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      new CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.indigoAccent,
                          dense: true,
                          //font change
                          title: new Text(
                            checkBoxListTileModel[index].title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                ),
                          ),
                          value: checkBoxListTileModel[index].isCheck,
                          secondary: Container(
                            height: 50,
                            width: 50,
                          ),
                          onChanged: (bool? val) {
                            itemChange(val!, index);
                          }
                          )
                    ],
                  ),
                ),
              );
            }),
          ])),
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
                      dataload(),
                    },
                    child: Text(
                      "Submit",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
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

class CheckBoxListTileModel {
  int userId;
  String title;
  bool isCheck;

  CheckBoxListTileModel({required this.userId, required this.title, required this.isCheck});

  static List<CheckBoxListTileModel> getUsers() {
    return <CheckBoxListTileModel>[
      CheckBoxListTileModel(
          userId: 1,
          title: "Adequate prepared for class",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 2,
          title: "Teaching method is effective and sessions are clear and understandable",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 3,
          title: "Make sessions lively, focused and interesting",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 4,
          title: "Has good command over the subject matter of the course",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 5,
          title: "Compare the topics with real life implementation  scenario",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 6,
          title: "Don't get angry fast and speak softly",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 7,
          title: "Listen to the students and help them to  solve problems",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 8,
          title: "Speaks loud enough and clearly",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 9,
          title: "Ensures fair exam conditions and strict proctoring",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 10,
          title: "Is student friendly and very nice toward students",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 11,
          title: "Follow the class lecture for  exam questions",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 12,
          title: "Is very strict about grading and don't curve at final grading",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 13,
          title: "Student evaluation criteria is not much complex",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 14,
          title: "Trust students to grade on online",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 15,
          title: "Follow  partial marking criteria in the exam",
          isCheck: false),
    ];
  }
}