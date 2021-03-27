import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wastegram_extended/config/constants.dart';

import 'package:wastegram_extended/models/post.dart';
import 'package:wastegram_extended/screens/listpage.dart';
import 'package:wastegram_extended/services/firestore_service.dart';
import 'package:wastegram_extended/widgets/camera_fab.dart';
import 'package:wastegram_extended/widgets/date_field_form.dart';
import 'package:wastegram_extended/widgets/my_scaffold.dart';

// Screen that allows modification of Post data: image, quantity, date, location
class ModifyPost extends StatefulWidget {
  static const String routeName = 'ModifyPost';
  final Post post;
  ModifyPost({Key key, @required this.post}) : super(key: key);
  @override
  _ModifyPostState createState() => _ModifyPostState();
}

class _ModifyPostState extends State<ModifyPost> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Modify Post',
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width / 15.0,
                            vertical: MediaQuery.of(context).size.width / 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: showInputs(post: widget.post),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          // Pin button to bottom of screen
          showButton(post: widget.post),
        ],
      ),
    );
  }

  List<Widget> showInputs({Post post}) {
    return <Widget>[
      TextFormField(
        controller: _quantityController,
        decoration: const InputDecoration(labelText: 'Quantity'),
        keyboardType: TextInputType.number,
        autocorrect: false,
        validator: (String val) {
          if (val == '' || int.tryParse(val) != null) {
            return null;
          }
          return 'Enter a valid quantity';
        },
      ),
      TextFormField(
        controller: _latitudeController,
        decoration: const InputDecoration(labelText: 'Latitude'),
        keyboardType: TextInputType.text,
        autocorrect: false,
        validator: (String val) {
          print('Lat: $val');
          if (val == '' ||
              (double.tryParse(val) != null &&
                  double.parse(val) >= minLat &&
                  double.parse(val) <= maxLat)) {
            return null;
          }
          return 'Enter a valid quantity';
        },
      ),
      TextFormField(
        controller: _longitudeController,
        decoration: const InputDecoration(labelText: 'Longitude'),
        keyboardType: TextInputType.text,
        autocorrect: false,
        validator: (String val) {
          print('Long: $val');
          if (val == '' ||
              (double.tryParse(val) != null &&
                  double.parse(val) >= minLong &&
                  double.parse(val) <= maxLong)) {
            return null;
          }
          return 'Enter a valid quantity';
        },
      ),
      MyDateFieldForm(
        onChanged: (date) => setState(() {
          post.date = Timestamp.fromDate(date);
        }),
        onSaved: (date) => setState(
          () {
            post.date = Timestamp.fromDate(date);
          },
        ),
      ),
      showImageButton(post: post),
    ];
  }

  Widget showImageButton({Post post}) {
    return // New image
        ElevatedButton.icon(
      onPressed: () async {
        // Update only if something is selected
        final String tempImg = await getNewImage() ?? post.imageURL;
        if (tempImg != '') {
          post.imageURL = tempImg;
        }
      },
      icon: const Icon(Icons.photo_camera),
      label: const Text('Select New Image'),
    );
  }

  Widget showButton({Post post}) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            validateUpdate(post: post).then((val) {
              Navigator.of(context).pushReplacementNamed(ListPage.routeName);
            });
          },
          child: const Text('Submit'),
        ),
      ),
    );
  }

  Future<void> validateUpdate({Post post}) async {
    // Validate all form fields, then either sign in or sign up with credentials
    if (_formKey.currentState.validate()) {
      try {
        // Update only if something is selected
        post.quantity = int.tryParse(_quantityController.text) == null
            ? post.quantity
            : int.parse(_quantityController.text);

        post.locationData = GeoPoint(
            double.tryParse(_latitudeController.text) != null
                ? double.parse(_latitudeController.text)
                : post.locationData.latitude,
            double.tryParse(_longitudeController.text) != null
                ? double.parse(_longitudeController.text)
                : post.locationData.longitude);

        await FirestoreService().updatePost(id: post.userID, post: post);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Post updated',
          ),
        ));
      } catch (e) {
        print(e);
      }
    }
  }
}
