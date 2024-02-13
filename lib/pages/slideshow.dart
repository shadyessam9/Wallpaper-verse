import 'dart:developer';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../widgets/app_bar.dart';

class SlideshowPage extends StatefulWidget {
  const SlideshowPage({Key? key}) : super(key: key);

  @override
  State<SlideshowPage> createState() => _SlideshowPageState();
}

class _SlideshowPageState extends State<SlideshowPage> {
  bool on = false;
  static const List<String> _list1 = [
    'Favorites',
    'Random',
  ];

  static const List<String> _list2 = [
    'Hours',
    'Days',
  ];

  int _currentValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'SlideShow', isSettingsPage: false
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(33, 33, 33, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Slide Wallpapers',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    CupertinoSwitch(
                      value: on,
                      activeColor: Colors.lightBlue,
                      onChanged: (bool value) {
                        setState(() {
                          on = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            IgnorePointer(
              ignoring: !on, // Disable interactions when switch is off
              child: Opacity(
                opacity: on ? 1.0 : 0.7, // Change opacity based on switch state
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(33, 33, 33, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CustomDropdown<String>(
                            items: _list1,
                            hintText: 'Select Source',
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(33, 33, 33, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CustomDropdown<String>(
                                  items: _list2,
                                  hintText: 'Select Duration',
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
                            ),
                            SizedBox(width: 10), // Add some space between the widgets
                            Expanded(
                              flex: 1,
                              child: NumberPicker(
                                textStyle: TextStyle(color: Colors.white70, fontSize: 15),
                                selectedTextStyle: TextStyle(color: Colors.white, fontSize: 30),
                                value: _currentValue,
                                minValue: 0,
                                maxValue: 100,
                                onChanged: (value) => setState(() => _currentValue = value),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
