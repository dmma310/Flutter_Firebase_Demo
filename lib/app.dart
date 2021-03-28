import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wastegram_extended/config/style.dart';
import 'package:wastegram_extended/route_generator.dart';
import 'package:wastegram_extended/services/analytics_service.dart';
import 'package:wastegram_extended/services/auth_provider.dart';
import 'package:wastegram_extended/services/auth_service.dart';
import 'package:wastegram_extended/widgets/auth_page_decider.dart';

class App extends StatefulWidget {
  static const String _title = 'Flutter Firebase Demo';
  static const String DARK_MODE_KEY = 'isDarkMode';
  // Used for persistence, storing data when app is closed/re-opened
  final SharedPreferences preferences;

  App({Key key, @required this.preferences}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  // Get stored value, set to false if none exists
  bool get isDarkMode => widget.preferences.getBool(App.DARK_MODE_KEY) ?? false;

  // Toggle Theme mode. Called in Drawer -> SwitchListTile
  void toggleThemeMode(bool val) {
    setState(
      () {
        widget.preferences.setBool(App.DARK_MODE_KEY, val);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show waiting page until firebase is initialized
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            // All widgets that inherit from AuthProvider will have access to same auth
            return AuthProvider(
              auth: AuthService(),
              // Subscribe to authentication changes to update screens (i.e. when user logs out or in)
              child: MaterialApp(
                title: App._title,
                theme: mainTheme(isDarkMode: this.isDarkMode),
                themeMode: this.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                darkTheme: mainTheme(isDarkMode: this.isDarkMode),
                onGenerateRoute: generateRoute,
                initialRoute: AuthPageDecider.routeName,
                navigatorObservers: [AnalyticsService().analyticsObserver],
              ),
            );
          } else if (snapshot.hasError) {
            return SafeArea(
              child: Center(
                child: const Text('Error connecting to database'),
              ),
            );
          }
          return const Center(child: const CircularProgressIndicator());
        });
  }
}

