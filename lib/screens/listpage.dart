import 'package:flutter/material.dart';
import 'package:wastegram_extended/models/post.dart';
import 'package:wastegram_extended/screens/post_detail.dart';
import 'package:wastegram_extended/services/firestore_service.dart';
import 'package:wastegram_extended/widgets/my_scaffold.dart';

class ListPage extends StatelessWidget {
  static const routeName = 'ListPage';
  const ListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirestoreService().currentFirestoreUserProperty(
            context: context,
            property:
                'userID'), // Returns current user ID from users collection, which matches Firebase Auth
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final String userID = snapshot.data;
            return StreamBuilder(
              // TODO: Filtering not working
              stream: FirestoreService()
                  .postsCollection
                  // .where('userID',
                  //     isEqualTo: AuthProvider.of(context).auth.currentUser())
                  .orderBy('date',
                      descending: true) // Sort and filter by current user
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data.docs != null &&
                    snapshot.data.docs.length > 0) {
                  // Get list of posts specific to user (or all posts if user is Admin)
                  List<dynamic> userPosts =
                      userPostsFromSnapshot(userID: userID, snapshot: snapshot);
                  return MyScaffold(
                    backButton: false,
                    title:
                        'Wastegram - ${userPosts.length}', // Show total number of posts
                    // Show Posts
                    body: showPosts(posts: userPostsFromSnapshot(userID: userID, snapshot: snapshot), userID: userID),
                    cameraFab: true,
                  );
                } else if (snapshot.hasError) {
                  return MyScaffold(
                    backButton: false,
                    title: 'Error',
                    body: Center(
                      child: Text(
                        '${snapshot.error}',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  );
                } else {
                  return MyScaffold(
                    backButton: false,
                    cameraFab: true,
                    title: 'Waiting for data...',
                    body: Center(
                      child: Text(
                        'Waiting for data...',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  );
                }
              },
            );
          }
          return MyScaffold(
            backButton: false,
            title: 'Getting User Info',
            body: Center(
              child: Text(
                'Getting User Info...',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          );
        });
  }
}

Widget showPosts({@required List<dynamic> posts, @required String userID}) {
  return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.blueGrey,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        // Build ListTile with contents of document
        Post post = Post.fromSnapshot(posts[index]);
        // Return ListTile with Confirmation before deleting (swiping right->left)
        return buildDismissiblePost(
            context: context, post: post, userID: userID);
      });
}

Dismissible buildDismissiblePost(
    {BuildContext context, @required Post post, @required userID}) {
  return Dismissible(
    key: UniqueKey(),
    child: ListTile(
      title: Text('${post.showDate}'),
      subtitle: Text('Role: ${post.userRole}'),
      trailing: Text(
        '${post.quantity}',
      ),
      onTap: () {
        Navigator.of(context).pushNamed(PostDetail.routeName, arguments: post);
      },
    ),
    confirmDismiss: (direction) async {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Delete?"),
              ),
            ],
          );
        },
      );
    },
    resizeDuration: null,
    onDismissed: (DismissDirection dir) async {
      if (dir == DismissDirection.startToEnd) {
        // Delete by post id
        await FirestoreService().deletePost(id: userID);
      }
    },
  );
}

List<dynamic> userPostsFromSnapshot(
    {@required userID, @required AsyncSnapshot<dynamic> snapshot}) {
  return snapshot.data.docs
      .where((entry) =>
          entry['userID'] == userID ||
          entry['userRole'].toLowerCase() == 'admin')
      .toList();
}
