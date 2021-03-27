// My custom scaffold widget
import 'package:flutter/material.dart';
import 'package:wastegram_extended/widgets/camera_fab.dart';
import 'package:wastegram_extended/widgets/drawer.dart';

class MyScaffold extends StatelessWidget {
  final bool backButton;
  final String title;
  final Widget body;
  final bool cameraFab;
  final bool resizeToAvoidBottomInset;
  final bool isLoggedin;

  const MyScaffold(
      {this.title,
      this.backButton = true,
      this.body,
      this.cameraFab = false,
      this.resizeToAvoidBottomInset = true,
      this.isLoggedin = false,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: this.resizeToAvoidBottomInset,
      appBar: AppBar(
        leading: backButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context)
                      // .pushReplacementNamed(ListPage.routeName);
                      .pop();
                })
            : null,
        title: Text(title),
        actions: [
          // Builder used to access Scaffold.of(context)...to open Drawer
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context)
                    .openEndDrawer(); // Open drawer on right side
              },
            );
          }),
        ],
      ),
      endDrawer: MyDrawer(),
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: cameraFab ? NewPostFab() : null,
    );
  }
}
