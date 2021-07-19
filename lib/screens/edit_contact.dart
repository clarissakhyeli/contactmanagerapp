import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditContact extends StatefulWidget {
  DocumentSnapshot docToEdit;
  EditContact({this.docToEdit});

  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contactNo = TextEditingController();
  TextEditingController cName = TextEditingController();
  TextEditingController cPhoneNo = TextEditingController();
  TextEditingController cAddress = TextEditingController();
  TextEditingController website = TextEditingController();


  @override
  void initState() {
    fullName = TextEditingController(text: widget.docToEdit.data['fullName']);
    email = TextEditingController(text: widget.docToEdit.data['email']);
    contactNo = TextEditingController(text: widget.docToEdit.data['contactNo']);
    cName = TextEditingController(text: widget.docToEdit.data['cName']);
    cPhoneNo = TextEditingController(text: widget.docToEdit.data['cPhoneNo']);
    cAddress = TextEditingController(text: widget.docToEdit.data['cAddress']);
    website = TextEditingController(text: widget.docToEdit.data['website']);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp, size: 17,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Contacts ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
        backgroundColor: Colors.blueGrey[400],
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                confirmationDialog(context, "Delete contacts?",
                positiveText: "Delete",
                positiveAction: () {
                  widget.docToEdit.reference.delete().whenComplete(() => Navigator.pop(context,

                  ));
                },
              );
          }),
          new IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: () {
                confirmationDialog(
                  context,
                  "Update contacts details?",
                  positiveText: "Update",
                  positiveAction: () {
                    widget.docToEdit.reference.updateData({
                      'fullName': fullName.text,
                      'email': email.text,
                      'contactNo': contactNo.text,
                      'cName': cName.text,
                      'cPhoneNo': cPhoneNo.text,
                      'cAddress': cAddress.text,
                      'website': website.text,

                    }).whenComplete(() => Navigator.pop(context)
                    );
                  },
                );
              }),
        ],
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
            child: new ListView(
              children: <Widget>[
                SizedBox(height:20.0),
                new ListTile(
                  leading: const Icon(Icons.account_circle),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: fullName,
                    decoration: new InputDecoration(
                      labelText: "Full Name",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.email_outlined),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: email,
                    decoration: new InputDecoration(
                      labelText: "Email",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: contactNo,
                    decoration: new InputDecoration(
                      labelText: "Contact Number",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: cName,
                    decoration: new InputDecoration(
                      labelText: "Company Name",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.work_outline_rounded),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: cPhoneNo,
                    decoration: new InputDecoration(
                      labelText: "Company Phone Number",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.place_outlined),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: cAddress,
                    decoration: new InputDecoration(
                      labelText: "Company Address",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: website,
                    decoration: new InputDecoration(
                      labelText: "Website",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
