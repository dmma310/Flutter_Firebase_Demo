import 'package:flutter/material.dart';
import 'package:wastegram_extended/app.dart';
import 'package:wastegram_extended/screens/business_card.dart';
import 'package:wastegram_extended/services/auth_provider.dart';

class MyDrawer extends StatelessWidget {
  // Can use builder to return Widget instead of Stateless Widget
  @override
  Widget build(BuildContext context) {
    // MyAppState must not be private
    // Used to find MyApp by looking up widget hierarchy to access and toggle theme. Performance penalties exist. See SwitchListTile.
    final AppState state = context.findAncestorStateOfType<AppState>();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: const Center(
              child: const Text(
                'Settings',
                style: const TextStyle(color: Colors.white, fontSize: 50.0,),
              ),
            ),
            decoration: BoxDecoration(
              color: state.isDarkMode ? Colors.black : Colors.blue,
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: state.isDarkMode,
            onChanged: (bool value) {
              state.toggleThemeMode(value); // Call function defined in MyApp
            },
            secondary: state.isDarkMode
                ? const Icon(Icons.lightbulb, color: Colors.yellowAccent)
                : const Icon(
                    Icons.lightbulb_outline_rounded,
                  ),
            activeColor: Colors.blue,
          ),
          const Divider(),
          ListTile(
              title: const Text('Developer Business Card'),
              leading: const Icon(Icons.person),
              trailing: const Icon(Icons.navigate_next),
              onTap: () =>
                  Navigator.of(context).pushNamed(BusinessCardPage.routeName)),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ElevatedButton(
                  child: const Text('Logout',
                      style: const TextStyle(fontSize: 17.0, color: Colors.white)),
                  onPressed: () => _signOut(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await AuthProvider.of(context).auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: const Text(
          'Successfully signed out.',
        ),
      ));
    } catch (e) {
      print(e);
    }
  }
}
