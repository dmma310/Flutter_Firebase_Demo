import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:wastegram_extended/config/constants.dart';
import 'package:wastegram_extended/models/post.dart';
import 'package:wastegram_extended/screens/listpage.dart';
import 'package:wastegram_extended/services/auth_provider.dart';
import 'package:wastegram_extended/services/firestore_service.dart';
import 'package:wastegram_extended/widgets/camera_fab.dart';

// Widget displays image, quantity input box, and button to upload.
class NewPostForm extends StatelessWidget {
  final _text = TextEditingController();
  final String imageRef;
  NewPostForm({Key key, @required this.imageRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Source: https://stackoverflow.com/questions/53424916/textfield-validation-in-flutter
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Show selected image or default image
        Image.asset(imageRef != '' ? imageRef : defaultAssetImgRef,
            // width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.0), // Get quantity
        TextField(
          controller: _text,
          autofocus: true,
          // Numbers only allowed
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Enter a quantity',
          ),
        ),
        const Spacer(),
        // Button to upload to Firestore
        GestureDetector(
          child: Container(
            height: MediaQuery.of(context).size.height / 12.0,
            width: double.infinity,
            child: const Icon(Icons.cloud_upload),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          onTap: () async {
            await FirestoreService().createPost(
                post: await setPostFields(context: context, imageRef: imageRef, qty: _text.text));
            Navigator.of(context).pushReplacementNamed(ListPage.routeName);
          },
        ),
      ],
    );
  }
}

// Set all Food Waste Post fields based on user selected image and quantity; gets current location and time
Future<Post> setPostFields({BuildContext context, String imageRef, String qty}) async {
  return Post(
    date: Timestamp.now(),
    locationData: await getLocation(),
    quantity: int.parse(qty),
    // If no image was selected, use default image in Firebase storage. This image is existing. Need error handling for if image does not exist
    imageURL:
        imageRef == '' ? defaultNetworkImgRef : await upLoadImage(imageRef),
    userID: AuthProvider.of(context).auth.currentFirebaseAuthUserID(),
    userRole: await FirestoreService().currentFirestoreUserProperty(context: context, property: 'userRole'),
  );
}

// Returns current location as a Geopoint
Future<GeoPoint> getLocation() async {
  var locationService = Location();
  try {
    var position = await locationService.getLocation();
    return GeoPoint(position.latitude, position.longitude);
  } catch (e) {
    print(e);
  }
  return GeoPoint(0, 0);
}
