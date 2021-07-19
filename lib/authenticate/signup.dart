import 'package:commons/commons.dart';
import 'package:contactmanagerapp/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class SignUp extends StatefulWidget {

  final Function toggleView;
  SignUp({ this.toggleView });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String name = '';
  String email = '';
  String contactNo = '';
  String cName = '';
  String cContactNo = '';
  String cAddress = '';
  String password = '';

  Widget _backButton() {
    return InkWell(
      onTap: (){
        Navigator.pop(context);
      },

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left_outlined, color: Colors.black),
            ),
            Text(
                'Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
              ),
              Positioned(top: 30, left: 0, child: _backButton()),
              /*Padding(
                padding: EdgeInsets.all(40.0),
              ),*/
              Padding(
                padding: EdgeInsets.all(5.0),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'SIGN UP',
                        style: TextStyle(color: Colors.blueGrey, fontSize: 30, fontWeight: FontWeight.bold
                        )
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Full Name",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      //controller: emailController,
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
                      // The validator receives the text that the user has entered.
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Full Name';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      //controller: emailController,
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
                      // The validator receives the text that the user has entered.
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Email';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Contact No. ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      //controller: emailController,
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
                      // The validator receives the text that the user has entered.
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Contact Number';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          contactNo = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Company Name",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      //controller: emailController,
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
                      // The validator receives the text that the user has entered.
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Company Name';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          cName = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Company Contact No. ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      //controller: emailController,
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
                      // The validator receives the text that the user has entered.
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Company Contact Number';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          cContactNo = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Company Address",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 4),
                    TextFormField(
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
                      // The validator receives the text that the user has entered.
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Company Address';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          cAddress = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 4),
                    TextFormField(
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
                      // The validator receives the text that the user has entered.
                      obscureText: true,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 139.0, vertical: 15.0)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.registerWithEmailAndPassword(name, email, contactNo, cName, cContactNo, cAddress, password);
                      setState(() {
                        successDialog(context, "Successfully Sign Up!");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      });
                      if(result == null) {
                        setState(() {
                          return errorDialog(context, 'Please supply a valid email');
                        });
                      }
                    }
                  },
                  child: Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

}