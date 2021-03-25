import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

// This class holds all info related to the business card screen
class BusinessCard {
  static const String _githubAuthority = 'github.com';
  static const String _githubPath = '/dmma310';
  static const String _githubUrl = 'https://' + _githubAuthority + _githubPath;
  static const String _emailAddress = 'made@oregonstate.edu';
  static const String _name = 'Dexter Ma';
  static const String _phoneNumber = '555 555 5555';
  static final String _phoneUri = 'sms:+' + _phoneNumber.replaceAll(' ', '');
  static const String _emailTo = 'mailto:' + _emailAddress;
  static const String _title = 'Software Engineer';
  static const String _photoUrl = 'assets/images/avatar.png';

  BusinessCard();
  String get githubAuthority => _githubAuthority;
  String get githubPath => _githubPath;
  String get githubUrl => _githubUrl;
  String get phoneNumber => _phoneNumber;
  String get emailAddress => _emailAddress;
  String get emailTo => _emailTo;
  String get name => _name;
  String get title => _title;
  String get photoUrl => _photoUrl;

  // Source: https://stackoverflow.com/questions/54301938/how-to-send-sms-with-url-launcher-package-with-flutter
  // Launch native messaging app, depending on Android or iOS
  void textMe() async {
    try {
      if (Platform.isAndroid) {
        final String uri = _phoneUri + '?body=Hello'; // Strip all whitespace
        await launch(uri);
      } else if (Platform.isIOS) {
        final String uri = _phoneUri +
            _phoneNumber.replaceAll(' ', '') +
            '&body=Hello'; // Strip all whitespace
        await launch(uri);
      }
    } catch (e) {
      print(e);
    }
  }

  // Source: https://pub.dev/packages/url_launcher
  // Launch URL
  void launchURL(final String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }
}
