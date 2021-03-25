import 'package:flutter/material.dart';
import 'package:wastegram_extended/widgets/camera_fab.dart';
import 'package:wastegram_extended/widgets/my_scaffold.dart';
import 'package:wastegram_extended/widgets/new_post_form.dart';

class NewPost extends StatelessWidget {
static const String routeName = 'NewPost';
const NewPost({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      resizeToAvoidBottomInset: false,
      title: 'New Post',
      body: FutureBuilder(
        future: getNewImage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NewPostForm(imageRef: snapshot.data);
          } else {
            return SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}