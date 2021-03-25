import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wastegram_extended/models/business_card.dart';
import 'package:wastegram_extended/config/style.dart';
import 'package:wastegram_extended/widgets/my_scaffold.dart';
/*
  The Business Card displays a photo, name, title, phone number, web site url (e.g., GitHub profile), and email address.
  When tapping the phone number, the device's text messaging app appears.
  When tapping the web site url, a web browser appears and displays that web page.
  Use text sizes, styles, fonts, and colors on this screen. For example, a colored non-white background with white fancy text.
  Use your photo, or any avatar photo, instead of the Placeholder.
  */

class BusinessCardPage extends StatelessWidget {
  static const String routeName = 'BusinessCardPage';
  final BusinessCard _businessCard = BusinessCard();
  static const verticalInsets = 10.0;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Business Card',
      body: Container(
        // Add any necessary padding needed to keep widget from being blocked by the system status bar, notches, holes, rounded corners, etc.SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Wrap each child in Flexible Widget to play nice with FractionallySizedBox (not used), and to prevent overflow of widgets
          children: [
            // Show image
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: verticalInsets,
              ),
              // Constrain image size
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: 50, minHeight: 50, maxWidth: 100, maxHeight: 100),
                child: Image.asset(_businessCard.photoUrl, fit: BoxFit.contain),
              ),
            ),
            // Show name
            Flexible(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalInsets),
                  child: Center(
                    // Set custom text style, defined in style.dart
                    child: Text(
                      _businessCard.name,
                      style: BusinessCardScreenHeaderTextStyle,
                    ),
                  ), // Use title text theme defined in myapp
                ),
              ),
            ),
            // Show job title
            Flexible(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalInsets),
                  child: Center(
                    // Set custom text style, defined in style.dart
                    child: Text(
                      _businessCard.title,
                      style: BusinessCardScreenHeaderTextStyle,
                    ), // Use title text theme defined in myapp
                  ),
                ),
              ),
            ),
            // Show and launch phone number
            Flexible(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalInsets),
                  child: Center(
                    // Use Inkwell instead of GestureDetector to show ripple effect on tap
                    child: InkWell(
                      splashColor: Theme.of(context).accentColor,
                      onTap: () => _businessCard.textMe(),
                      // Set custom text style, defined in style.dart
                      child: Text(
                        _businessCard.phoneNumber,
                        style: BusinessScreenBodyTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Show website url and email address on same row
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Use Inkwell instead of GestureDetector to show ripple effect on tap
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      splashColor: Theme.of(context).accentColor,
                      onTap: () {
                        launch(_businessCard.githubUrl);
                      },
                      child: Text(
                        _businessCard.githubAuthority +
                            _businessCard.githubPath,
                        style: BusinessScreenBodyTextStyle,
                      ),
                    ),
                  ),
                  // Use Inkwell instead of GestureDetector to show ripple effect on tap
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      splashColor: Theme.of(context).accentColor,
                      onTap: () {
                        try {
                          _businessCard.launchURL(_businessCard.emailTo);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text(
                        _businessCard.emailAddress,
                        style: BusinessScreenBodyTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
