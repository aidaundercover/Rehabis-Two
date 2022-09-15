import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/views/profile/settings/reminder.dart';

import 'settings/picking_closed_ones.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List tiles = [
    {
      'icon': Icons.edit,
      'title': "My Profile",
      'page': Reminder(),
    },
    {'icon': Icons.notification_add, 'title': "Reminder", 'page': Reminder()},
    {'icon': Icons.speaker, 'title': "Sound Options", 'page': Reminder()},
    {
      'icon': Icons.emergency,
      'title': "Emergency Contacts",
      'page': PickingClosedOnes()
    },
  ];

  Widget createTile(String title, IconData icon, Widget page) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(fontFamily: "Inter"),
        ),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                    title: Text(
                      "Settings",
                      style:
                          TextStyle(fontFamily: "Inter", color: Colors.black54),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                    ))
              ],
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: width * 0.8,
                child: Column(children: [
                  Column(
                    children: [
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Back Up & Restore",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 20),
                                    ),
                                    Image.asset(
                                      'assets/google.png',
                                      height: 50,
                                    )
                                  ],
                                ),
                                Text(
                                  "Sign In and sycnhronize your data",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14),
                                )
                              ],
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.sync,
                                  color: primaryColor,
                                  size: 26,
                                ))
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.6,
                    child: ListView.builder(
                      itemCount: tiles.length,
                      itemBuilder: (context, i) => createTile(tiles[i]["title"],
                          tiles[i]["icon"], tiles[i]["page"]),
                    ),
                  ),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(
                        color: primaryColor, fontFamily: 'Inter', fontSize: 14),
                  )
                ]),
              ),
            ),
          )),
    );
  }
}
