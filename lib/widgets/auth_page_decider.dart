import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wastegram_extended/screens/listpage.dart';
import 'package:wastegram_extended/services/auth_provider.dart';
import 'package:wastegram_extended/screens/login_signup.dart';

// Source: https://github.com/bizz84/coding-with-flutter-login-demo/tree/onAuthStateChanged
class AuthPageDecider extends StatelessWidget {
  const AuthPageDecider({Key key}) : super(key: key);
  static const String routeName = 'AuthPageDecider';

  @override
  Widget build(BuildContext context) {
    // Subscribe to changes to state of user and update app screens to login/signup or list page
    return StreamBuilder(
        stream: AuthProvider.of(context).auth.authStateChanges,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            Navigator.of(context).popUntil((_) => true);
            return snapshot.hasData ? ListPage() : LoginSignupPage();
          }
          return const Center(child: const CircularProgressIndicator());
        });
  }
}
