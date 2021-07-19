import 'package:contactmanagerapp/authenticate/authenticate.dart';
import 'package:contactmanagerapp/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);

    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      print(user);
      return HomeScreen();
    }
  }
}