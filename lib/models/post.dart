import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Post {
  Timestamp date;
  int quantity;
  String imageURL;
  GeoPoint locationData;
  String userID;
  String userRole;

  Post({this.date, this.imageURL = '', this.quantity = 0, this.locationData, this.userID = '', this.userRole = 'User'}) {
    date = date ?? Timestamp.now();
    locationData = locationData ?? GeoPoint(0, 0);
  }

  // Format date for display
  String get showDate =>
      '${DateFormat('EEEE').format(date.toDate())}, ${DateFormat.yMMMMd().format(date.toDate())}'; // Thursday, December 12, 2021

  // Convert snapshot to model object
  // TODO: Error handling, when field doesn't exist
  Post.fromSnapshot(QueryDocumentSnapshot snapshot)
      : date = snapshot['date'],
        quantity = snapshot['quantity'],
        imageURL = snapshot['imageURL'],
        locationData = snapshot['locationData'],
        userRole = snapshot['userRole'],
        userID = snapshot['userID'];

  // Return model object as json map
  Map<String, dynamic> toJson() => {
        "date": this.date,
        "quantity": this.quantity,
        "imageURL": this.imageURL,
        "locationData": this.locationData,
        "userID": this.userID,
        "userRole": this.userRole,
      };
}