import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fks/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:fks/Screens/login/login.dart';
import 'package:fks/components/appback.dart';
import 'package:fks/Screens/profile.dart';
import 'package:fks/Screens/Rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late final User __user;
List<String> __name = [];
var score = new Map();
var facini = new Map();
var fname = new Map();
var fdep = new Map();
var flink = new Map();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required User user}): _user = user, super(key: key);
  final User _user;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  String? _result;

  TextEditingController searchController = TextEditingController();

  @override
  void click() {
    signOutGoogle();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    // __user = widget._user;
    checklogin();
    super.initState();
    dataload();
  }

  void checklogin() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      __user=user;
    }
    else {
      __user=user!;
    }
  }


  dataload() async {
    var collection = FirebaseFirestore.instance.collection('Faculty');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      String name = data['name'] + " (" + data['initial'] + ")";
      __name.add(name);
      score[name] = data['score'];
      facini[name] = data['initial'];
      fname[name] = data['name'];
      fdep[name] = data['department'];
      flink[name] = data['link'];
    }
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: __user,)));
                  },
                  child: ListTile(
                    leading: Image.network(
                      __user.photoURL!,
                      fit: BoxFit.fitHeight,
                    ),
                    title: Text(__user.displayName!),
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user: __user)));
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
            GestureDetector(
              onTap: () async {
                var result = await showSearch<String>(
                  context: context,
                  delegate: CustomDelegate(),
                );
                setState(() => _result = result);
              },
        child: Container(
          margin: EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.indigoAccent[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(
            offset: Offset(0, 15),
            blurRadius: 27,
            color: Colors.black26, // Black color with 12% opacity
          )],
        ),
        child: ListTile(
          leading: Icon(Icons.search),
          title: Text(
          "Search your Faculty",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        ),
      ),
    ),
      Expanded(
        child: Stack(
          children: <Widget>[
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Faculty').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                    children: snapshot.data!.docs.map((document) {
                // return ListView.builder(
                  // itemCount: myname.length,
                  // itemBuilder: (context, int index) =>
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
                        child: GestureDetector(
                          onTap: ()=> {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                RateScreen(
                                  user: __user,
                                  initial: document["initial"],
                                  name: document["name"],
                                  department: document["department"],
                                  link: document["link"],
                                  score: document["score"],
                                )))
                          },
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
                            leading: Image.asset("assets/images/mam.png"),
                            title: Text(
                              "${document["name"]}\n${document["initial"]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                                new Container(
                                  height: 30,
                                  width: 50,
                                  margin: const EdgeInsets.only(left: 240, top: 40, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    color: Colors.cyan[300],
                                  ),
                                  child: Text(
                                    "${document["score"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                          ),
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


class CustomDelegate extends SearchDelegate<String>{
  List<String> _name = __name;


  @override
  List<Widget> buildActions(BuildContext context) => [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(icon: Icon(Icons.chevron_left), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> name = [];

    if (query.isNotEmpty)
      name = _name.where((e) => e.toLowerCase().contains(query.toLowerCase())).toList();
    else
      name = _name;

    return ListView.builder(
      itemCount: name.length,
      itemBuilder: (_, i) {
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
          child: GestureDetector(
            onTap: () =>
            {
              __name=[],
              // __name = name,
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                      RateScreen(
                        user: __user,
                        initial: facini[name[i]],
                        name: fname[name[i]],
                        department: fdep[name[i]],
                        link: flink[name[i]],
                        score: score[name[i]],
                      )))
            },
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
                    leading: Image.asset("assets/images/mam.png"),
                    title: Text(
                      "${name[i]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  new Container(
                    height: 30,
                    width: 50,
                    margin: const EdgeInsets.only(
                        left: 240, top: 40, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      color: Colors.cyan[300],
                    ),
                    child: Text(
                      "${score[name[i]]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
