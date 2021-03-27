import 'package:flutter/material.dart';
import 'package:wastegram_extended/config/constants.dart';
import 'package:wastegram_extended/models/post.dart';
import 'package:wastegram_extended/screens/modify_post.dart';
import 'package:wastegram_extended/widgets/my_scaffold.dart';

class PostDetail extends StatelessWidget {
  static const String routeName = 'PostDetail';
  final Post post;
  PostDetail({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Posts',
      body: details(context),
    );
  }

  Widget details(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  // Center is scrollable
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 40.0),
                          child: Text(
                            post.showDate,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        imageWidget(context, post.imageURL),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 60.0),
                          child: Center(
                            child: Text(
                              'Items: ${post.quantity}',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 20.0),
                          child: Center(
                            child: Text(
                              '(${post.locationData.latitude}, ${post.locationData.latitude})',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Fixed at the bottom
        Container(
          alignment: Alignment.bottomCenter,
          color: Theme.of(context).primaryColor,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ModifyPost.routeName, arguments: post);
              },
              child: const Text('Modify Post'),
            ),
          ),
        ), // Fixed at the top
      ],
    );
  }
}

Widget imageWidget(BuildContext context, String imageURL) {
  return Padding(
    padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 20.0,
        horizontal: MediaQuery.of(context).size.width / 20.0),
    // If no image was selected and no default image exists in Firebase Storage, return Placeholder
    child: imageURL == ''
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Placeholder(),
          )
        : imageURL == defaultAssetImgRef
            ? Image.network(
                imageURL,
                width: MediaQuery.of(context).size.width,
              )
            : Image.asset(
                defaultAssetImgRef,
                width: MediaQuery.of(context).size.width,
              ),
  );
}
