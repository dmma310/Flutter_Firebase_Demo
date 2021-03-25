import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wastegram_extended/app.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  // // Rebuild when device orientation changes, only these are enabled.
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(App(preferences: await SharedPreferences.getInstance()));
}
