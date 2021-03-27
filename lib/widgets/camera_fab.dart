import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:wastegram_extended/screens/new_post.dart';

class NewPostFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.post_add),
      onPressed: () async {
        Navigator.of(context).pushNamed(NewPost.routeName);
      },
      backgroundColor: Theme.of(context).primaryColor,);
  }
}

Future<String> getNewImage({var src = ImageSource.gallery}) async {
  try {
    final picked = await ImagePicker().getImage(source: src);
    return picked == null ? '' : picked.path;
  } catch (e) {
    print(e);
  }
  return '';
}

Future<String> getExistingImage(String name) async {
  try {
    final url =
        await FirebaseStorage.instance.ref().child(name).getDownloadURL();
    return url.toString();
  } catch (e) {
    print(e);
  }
  return '';
}

Future<String> upLoadImage(String imageRef) async {
  // If using hardware device, use ImageSource.camera
  // ignore: deprecated_member_use
  if (imageRef != '') {
    final Reference storageReference = FirebaseStorage.instance.ref().child(
          Path.basename(
            imageRef + DateTime.now().toString(),
          ),
        );
    // Upload image to Firebase storage and return url to image
    final UploadTask uploadTask = storageReference.putFile(File(imageRef));

    uploadTask.whenComplete(() async {
      try {
        final String url = await storageReference.getDownloadURL();
        return url.toString();
      } catch (e) {
        print(e);
      }
    }).catchError((onError) {
      print(onError);
    });
  }
  return imageRef;
}
