import 'package:contactmanagerapp/services/auth.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final AuthService authService;

  Provider({Key key, Widget child, this.authService}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>();
  }
}
