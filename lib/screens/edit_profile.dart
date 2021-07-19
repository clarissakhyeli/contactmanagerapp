import 'package:commons/commons.dart';
import 'package:contactmanagerapp/models/user.dart';
import 'package:contactmanagerapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
          print(userData.email);
          print(userData.cAddress);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_sharp, size: 17,),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text('Edit Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              backgroundColor: Colors.blueGrey[400],
              centerTitle: true,
              elevation: 0.0,
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:30.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 4),
                          TextFormField(
                            initialValue: userData.name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(14),
                            ),
                            validator: (val) => val.isEmpty ? 'Please enter full name' : null,
                            onChanged: (val) => setState(() => _currentName = val),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Email",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 4),
                          TextFormField(
                            initialValue: userData.email,
                            enabled: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(14),
                            ),
                            validator: (val) => val.isEmpty ? 'Please enter email' : null,
                            onChanged: (val) => setState(() => _currentEmail = val),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Contact No. ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 4),
                          TextFormField(
                            initialValue: userData.contactNo,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(14),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Company Name",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 4),
                          TextFormField(
                            initialValue: userData.cName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(14),
                            ),
                            validator: (val) => val.isEmpty ? 'Please enter Company Name' : null,
                            onChanged: (val) => setState(() => _companyName = val),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Company Contact No. ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 4),
                          TextFormField(
                            initialValue: userData.cContactNo,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(14),
                            ),
                            validator: (val) => val.isEmpty ? 'Please enter Company Contact Number' : null,
                            onChanged: (val) => setState(() => _companyContactNo = val),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Company Address",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 4),
                          TextFormField(
                            initialValue: userData.cAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(14),
                            ),
                            validator: (val) => val.isEmpty ? 'Please enter Company Address' : null,
                            onChanged: (val) => setState(() => _companyAddress = val),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10.0, right: 17.0),
              child : FloatingActionButton.extended(

                  label: Text("Update", style: TextStyle(color: Colors.white),),
                    icon: Icon(Icons.save, color: Colors.white,),
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    onPressed: () async {
                      confirmationDialog(
                          context,
                          "Update Profile?",
                          positiveText: "Update",
                          positiveAction: () async {
                            if(_formKey.currentState.validate()) {
                              await DatabaseService(uid: user.uid).updateUserData(
                                  _currentName ?? snapshot.data.name,
                                  _currentEmail ?? snapshot.data.email,
                                  _currentContactNo ?? snapshot.data.contactNo,
                                  _companyName ?? snapshot.data.cName,
                                  _companyContactNo ?? snapshot.data.cContactNo,
                                  _companyAddress ?? snapshot.data.cAddress
                              );
                              Navigator.pop(context);
                            }
                          },
                      );

                    }),
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

