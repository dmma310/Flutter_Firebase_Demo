import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver get analyticsObserver =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logLogin() async {
    await _analytics.logLogin();
  }

  Future<void> logSignUp() async {
    await _analytics.logSignUp(signUpMethod: 'User signed up');
  }

  Future<void> logModifyPost({final String screenName}) async {
    await _analytics.setCurrentScreen(screenName: screenName, screenClassOverride: screenName);
  }

  // Track and associate all events with current user
  Future<void> setUserProperties({@required String userID, @required String userRole}) async {
    await _analytics.setUserId(userID);
    await _analytics.setUserProperty(name: 'user_role', value: userRole);
  }
}
