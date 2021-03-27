# wastegram_extended

* Intro
Build an application for recording food waste. Practice applying the concepts of location services, camera / image picker, permissions, forms, navigation, lists, asynchronous programming, streams, and Firebase backend services. Enhance your application with analytics, crash reporting, accessibility, internationalization, debugging and automated testing.
samples, guidance on mobile development, and a full API reference.

Mobile app that enables employees to document daily food waste in the form of "posts" consisting of a photo, number of leftover items, the current date, and the location of the device when the post is created. The application provides CRUD functionality with Firebase Firestore and also displays a list of all previous posts, which are also stored in Firebase Firestore.

In addition, uses Firebase Auth to authenticate and verify users for role-based displays, and shared preferences to update theme.

NOTE: Must use own GoogleService-Info.plist & google-services.json configuration files for Firebase