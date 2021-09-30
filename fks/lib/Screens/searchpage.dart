
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fks/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:fks/Screens/login/login.dart';
import 'package:fks/components/appback.dart';
import 'package:fks/Screens/profile.dart';
import 'package:fks/Screens/Rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fks/Screens/home.dart';

late final User __user;
List<String> __name = [];
var score = new Map();

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required User user}): _user = user, super(key: key);
  final User _user;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _result;
  late User _user;

  @override
  void initState() {
    _user = widget._user;
    __user = widget._user;
    super.initState();
    dataload();
  }
  dataload() async {
    var collection = FirebaseFirestore.instance.collection('Faculty');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      String name = data['name'] + " (" + data['initial'] + ")";
      __name.add(name);
      score[name] = data['score'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(_result ?? '', style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () async {
                var result = await showSearch<String>(
                  context: context,
                  delegate: CustomDelegate(),
                );
                setState(() => _result = result);
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDelegate extends SearchDelegate<String>{
  late User _user = __user;
  List<String> _name = __name;


  @override
  List<Widget> buildActions(BuildContext context) => [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(icon: Icon(Icons.chevron_left), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    var name;
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
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                      RateScreen(
                        user: _user, name: name[i],)))
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
