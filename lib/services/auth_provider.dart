import 'package:flutter/material.dart';
import 'package:wastegram_extended/services/auth_service.dart';

// Widget placed at top of hierarchy, so that we can propagate info down the tree without passing or creating new AuthService instances
class AuthProvider extends InheritedWidget {
  const AuthProvider({Key key, Widget child, this.auth}) : super(key: key, child: child);
  final AuthService auth; // Thing we want children to have access to

  // Notify widgets that inherit from this widget.
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  // Provides access to AuthProvider
  static AuthProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
  }
}