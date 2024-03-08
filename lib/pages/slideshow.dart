import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_bar.dart';

class SlideshowPage extends StatefulWidget {
  const SlideshowPage({Key? key}) : super(key: key);

  @override
  State<SlideshowPage> createState() => _SlideshowPageState();
}

class _SlideshowPageState extends State<SlideshowPage> {
  late SharedPreferences _prefs;
  bool _prefsInitialized = false;
  bool on = false;
  bool slideState = false;
  String selectedSource = '';
  String selectedTarget = '';
  String selectedCategory = '';
  String selectedType = '';
  String durationType = '';


    @override
  void initState() {
    super.initState();
    _initPrefs();
  }


  static const List<String> _list1 = [
    'Favorites',
    'Random'
  ];

  static const List<String> _list2 = [
    'HomePage',
    'LockScreen',
    'HomePage & LockScreen'
  ];

    static const List<String> _list3 = [
    'On UnLocking',
    'Every Hour',
    'Every Day'
  ];




void _initPrefs() async {
  _prefs = await SharedPreferences.getInstance();
  setState(() {_prefsInitialized = true;});
}

  // Save selected value to SharedPreferences
  Future<void> _saveSelectedValue<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else {
      throw Exception("Unsupported value type");
    }
  }



  @override
  Widget build(BuildContext context) {
    if (!_prefsInitialized) {
      // Return a loading indicator or fallback widget while _prefs is being initialized
      return CircularProgressIndicator(); // Example of a loading indicator
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: 'SlideShow',
        isSettingsPage: false,
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
                      value: on = _prefs.getBool('slideState') ?? false,
                      activeColor: Colors.lightBlue,
                      onChanged: (bool value) {
                        setState(() {
                          on = value;
                          slideState = on;
                          _saveSelectedValue('slideState', value);
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
                            initialItem:  _prefs.getString('selectedSource') ?? _list1.first,
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
                            onChanged: (String value) {
                              setState(() {

                               _saveSelectedValue('selectedSource', value);
                              });
                            },
                          ),
                        ),
                      ),
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
                            initialItem: _prefs.getString('selectedTarget') ?? _list2.first,
                            items: _list2,
                            hintText: 'Select Target',
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
                            onChanged: (String value) {
                              setState(() {
                                // Handle enabling/disabling of NumberPicker based on the selected source
                                _saveSelectedValue('selectedTarget', value);
                              });
                            },
                          ),
                        ),
                      ),
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
                            initialItem:  _prefs.getString('durationType') ?? _list3.first,
                            items: _list3,
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
                            onChanged: (String value) {
                              setState(() {
                               _saveSelectedValue('durationType', value);
                              });
                            },
                          ),
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