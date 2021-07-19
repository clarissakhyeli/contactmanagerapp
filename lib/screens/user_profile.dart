import 'package:contactmanagerapp/authenticate/login.dart';
import 'package:contactmanagerapp/models/user.dart';
import 'package:contactmanagerapp/screens/edit_profile.dart';
import 'package:contactmanagerapp/services/auth.dart';
import 'package:contactmanagerapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserProfileScreen extends StatefulWidget {
  static const route = '/third';

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _currentName;
  String _currentEmail;
  String _currentContactNo;
  String _companyName;
  String _companyContactNo;
  String _companyAddress;

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserData userData = snapshot.data;
          _currentName = userData.name;
          _currentEmail = userData.email;
          _currentContactNo = userData.contactNo;
          _companyName = userData.cName;
          _companyContactNo = userData.cContactNo;
          _companyAddress = userData.cAddress;

          return Scaffold(
            appBar:  AppBar(
              title: Text('User Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              backgroundColor: Colors.blueGrey[400],
              centerTitle: true,
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person, color: Colors.white,),
                  label: Text('LOGOUT',  style: TextStyle(color: Colors.white),),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
                  },
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 45.0),

                child: Stack(
                  children: <Widget>[
                    Card(
                      margin: const EdgeInsets.only(top: 80.0, right: 10.0, left: 10.0),
                      child: SizedBox(
                          height: 150.0,
                          width: 390,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "$_currentName",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                ),
                                SizedBox(height: 12,),
                                Text("$_currentEmail")
                              ],
                            ),
                          )),
                    ),
                    Positioned(
                      top: .0,
                      left: .0,
                      right: .0,
                      child: Center(
                        child: ClipRRect(
                          child: Image.asset('image/user.png',
                              width: 140,
                              height: 140,
                              fit:BoxFit.cover),

                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            ],
                          ),
                          SizedBox(height: 155),
                          Text(
                            "Contact No.:  ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8),
                          Text("$_currentContactNo"),
                          SizedBox(height: 15),
                          Text(
                            "Company Name:  ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8),
                          Text("$_companyName"),
                          SizedBox(height: 15),
                          Text(
                            "Company Contact No.:  ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8),
                          Text("$_companyContactNo"),
                          SizedBox(height: 15),
                          Text(
                            "Company Address:  ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8),
                          Text("$_companyAddress"),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: Stack(
              children: <Widget>[
                FloatingActionButton(
                    child: Icon(CupertinoIcons.pencil, color: Colors.white,),
                    backgroundColor: Colors.blueGrey[400],
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                    }),
              ],
            ),
          );
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
