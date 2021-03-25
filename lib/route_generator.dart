import 'package:flutter/material.dart';
import 'package:wastegram_extended/screens/business_card.dart';
import 'package:wastegram_extended/screens/listpage.dart';
import 'package:wastegram_extended/screens/login_signup.dart';
import 'package:wastegram_extended/screens/new_post.dart';
import 'package:wastegram_extended/screens/post_detail.dart';
import 'package:wastegram_extended/widgets/auth_page_decider.dart';

// Source: https://www.youtube.com/watch?v=nyvwx7o277U
// Manage which route/page to show whenever: Navigator.of(context).pushNamed('some_name', arguments: some_args)
// In MaterialApp, set the onGenerateRoute parameter to this function
Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case AuthPageDecider.routeName:
      return MaterialPageRoute(builder: (context) => const AuthPageDecider());
    case LoginSignupPage.routeName:
      return MaterialPageRoute(builder: (context) => LoginSignupPage());
    case NewPost.routeName:
      return MaterialPageRoute(builder: (context) => const NewPost());
    case PostDetail.routeName:
      return MaterialPageRoute(builder: (context) => PostDetail(post: args));
    case ListPage.routeName:
      return MaterialPageRoute(builder: (context) => const ListPage());
    case BusinessCardPage.routeName:
      return MaterialPageRoute(builder: (context) => BusinessCardPage());
    default:
      return _errorRoute();
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: const Text('Error'),
        ),
      );
    },
  );
}
