import 'package:chatui/pages/events_page.dart';
import 'package:chatui/pages/home_page.dart';
import 'package:chatui/pages/profile_page.dart';
import 'package:chatui/pages/user_page.dart';
import 'package:chatui/pages/resources_page.dart';
import 'package:chatui/services/auth/auth_service.dart';
import 'package:chatui/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    // get auth service

    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                //logo
               DrawerHeader(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.primary,
  ),
  child: Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SDAcro',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),
        Icon(
          Icons.sports_gymnastics,
          color: Colors.white,
          size: 60,
        ),
      ],
    ),
  ),
),

                //home list tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text(" H O M E"),
                    leading: const Icon(Icons.home),
                    onTap: () {
                      // pop the drawer
                      Navigator.pop(context);

                       Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                ),

                //chat list tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("C H A T"),
                    leading: const Icon(Icons.chat),
                    onTap: () {
                      // pop the drawer
                      Navigator.pop(context);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => UserPage()));
                    },
                  ),
                ),

                //resources list tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("R E S O U R C E S"),
                    leading: const Icon(Icons.video_library),
                    onTap: () {
                      // pop the drawer
                      Navigator.pop(context);

                      // navigate to settings

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResourcesPage()));
                    },
                  ),
                ),

                //events list tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("E V E N T S"),
                    leading: const Icon(Icons.calendar_month),
                    onTap: () {
                      // pop the drawer
                      Navigator.pop(context);

                      // navigate to settings

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventsPage()));



                              
                    },
                  ),
                ),


                //profile 
 Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("P R O F I L E"),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      // pop the drawer
                      Navigator.pop(context);

                      // navigate to settings

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    },
                  ),
                ),
                //settings list tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("S E T T I N G S"),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      // pop the drawer
                      Navigator.pop(context);

                      // navigate to settings

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()));
                    },
                  ),
                ),
              ],
            ),







            //logout

            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
              child: ListTile(
                title: const Text("L O G O U T"),
                leading: const Icon(Icons.logout),
                onTap: logout,
              ),
            ),
          ],
        ));
  }
}
