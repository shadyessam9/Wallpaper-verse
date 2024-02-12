import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_verse/theme/model.dart';
import 'package:wallpaper_verse/theme/theme_colors.dart';

import '../widgets/app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool on = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Single color for the page
      appBar: CustomAppBar(
        title: 'Settings',
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(33, 33, 33, 1), // Single color for the container
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Dark Mode',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CupertinoSwitch(
                          value: on,
                          activeColor: Colors.lightBlue,
                          onChanged: (bool value) {},
                        )
                      ],
                    ),
                  ),
                ),
                // Privacy Policy
                // T and Cs
                // About section
              ],
            ),
          )
        ],
      ),
    );
  }
}
