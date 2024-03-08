import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Single color for the page
      appBar: CustomAppBar(
        title: 'Profile',
        isSettingsPage: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            color: Color.fromRGBO(33, 33, 33, 1),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Container(
                color: Color.fromRGBO(33, 33, 33, 1),
                child: Text(
                  'Name',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Container(
                color: Color.fromRGBO(33, 33, 33, 1),
                child: Text(
                  'Email',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Container(
                color: Color.fromRGBO(33, 33, 33, 1),
                child: Text(
                  'Password',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 10,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Log Out',
                          style: TextStyle(fontSize: 20,color: Colors.white),
                        ),
                      ),
                    )
                  ]
              )
            ),Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
                        Text('WallpaperVerse ®', style: TextStyle(fontSize: 15,color: Colors.white)),
                        Text('Version 1.0', style: TextStyle(fontSize: 15,color: Colors.white))
                      ])
                    ]
                )
            )
          ],
        ),
      ),
    );
  }
}
