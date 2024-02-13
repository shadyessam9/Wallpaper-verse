import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const List<String> _list1 = [
    'Favorites',
    'Random',
  ];

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
                child: TextFormField(
                  initialValue: 'Name',
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white), // Set initial border color to white
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white), // Set focused border color to white
                    ),
                    suffixIcon: Icon(
                      Icons.person,
                      color: Colors.white, // Set icon color to white
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Container(
                color: Color.fromRGBO(33, 33, 33, 1),
                child: TextFormField(
                  initialValue: 'Email',
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white), // Set initial border color to white
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white), // Set focused border color to white
                    ),
                    suffixIcon: Icon(
                      Icons.email,
                      color: Colors.white, // Set icon color to white
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Container(
                color: Color.fromRGBO(33, 33, 33, 1),
                child: TextFormField(
                  initialValue: 'Password',
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white), // Set initial border color to white
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white), // Set focused border color to white
                    ),
                    suffixIcon: Icon(
                      Icons.password,
                      color: Colors.white, // Set icon color to white
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: CustomDropdown<String>(
                items: _list1,
                hintText: 'Select Language',
                closedHeaderPadding: const EdgeInsets.all(15),
                maxlines: 2,
                listItemBuilder: (context, item, isSelected, onItemSelect) {
                  return Text(
                    item.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  );
                },
                decoration: CustomDropdownDecoration(
                  closedFillColor: Color.fromRGBO(33, 33, 33, 1),
                  expandedFillColor: Color.fromRGBO(33, 33, 33, 1),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  headerStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  noResultFoundStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  closedSuffixIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  expandedSuffixIcon: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  ),
                ),
                onChanged: (String) {},
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
