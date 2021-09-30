import 'package:firebase_auth/firebase_auth.dart';
import 'package:fks/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:fks/Screens/login/login.dart';
import 'package:fks/Screens/home.dart';
import 'package:fks/components/appback.dart';
import 'package:fks/Screens/profile.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({Key? key,
    required User user,
    required String initial,
    required String name,
    required String department,
    required String link,
    required String score,
  }):
        _user = user,
        _initial=initial,
        _department=department,
        _name=name,
        _link=link,
        _score=score,

        super(key: key);
  final User _user;
  final String _initial;
  final String _name;
  final String _department;
  final String _link;
  final String _score;

  @override
  _RateScreenState createState() => _RateScreenState();
}
class _RateScreenState extends State<RateScreen> {
  late User _user;
  late String initial, name, department, link, score;

  @override
  void initState() {
    _user = widget._user;
    initial = widget._initial;
    name=widget._name;
    department=widget._department;
    link=widget._link;
    score=widget._score;
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
        title: Text("Faculty's Score"),
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
            SizedBox(height: size.height * 0.05),
            Container(
              child: ListTile(
                leading: Image.asset("assets/images/mam.png"),
                title: Text(
                  "${name}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.indigo,
                  ),
                ),
                subtitle: Text(
                  "${initial}, ${department}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
      Expanded(
        child: Stack(
          children: <Widget>[
            ListView(children: <Widget>[
              Center(
                  child: Text(
                    'SCORE',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  )),
              DataTable(
                columns: [
                  DataColumn(label: Text(
                      'Type',
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)
                  )),
                  DataColumn(label: Text(
                      'Point',
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)
                  )),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('Over-All',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    DataCell(Text("${score}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Teaching',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    DataCell(Text('0',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Garding',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    DataCell(Text('0',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Friendly',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    DataCell(Text('0',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ]),
                ],
              ),
            ]),
          ],
        ),
      ),
          ],
        ),
      ),
    );
  }
}
