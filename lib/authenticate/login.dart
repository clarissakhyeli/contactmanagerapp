import 'package:commons/commons.dart';
import 'package:contactmanagerapp/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'signup.dart';

class LogIn extends StatefulWidget {
  final Function toggleView;
  LogIn({ this.toggleView });

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';

  showOKAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
        onPressed: () {},
        child: Text("OK"));

    AlertDialog alertDialog = AlertDialog(
      title: Text("Failed to Login"),
      content: Text("Email or Password is incorrect!"),
      actions: [
        okButton,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(70.0),
              ),
              Padding(
                padding: EdgeInsets.all(50.0),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'LOGIN',
                        style: TextStyle(color: Colors.blueGrey, fontSize: 40, fontWeight: FontWeight.bold
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
                      "Email",
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
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                      obscureText: true,
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 139.0, vertical: 15.0)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate() == true ) {
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if(result == null) {
                        setState(() {
                         // return 'Could not log in with those credentials';
                         return errorDialog(context,
                             "Email or Password is incorrect!");
                             });
                      }
                    } else {
                      setState(() {
                        // return 'Could not log in with those credentials';
                        return errorDialog(context,
                            "Do you want to create an account?");
                      });
                    }

                  },
                  child: Text('Log In'),

                ),
              ),

              Padding(
                  padding: EdgeInsets.all(2.0),
                  child: GestureDetector(
                      child: Text("Don\'t have an account? ",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
