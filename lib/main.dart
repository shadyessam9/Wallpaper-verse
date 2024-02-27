import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_verse/firebase_options.dart';
import 'package:wallpaper_verse/main_home.dart';
import 'package:wallpaper_verse/theme/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

 @override
  void initState() {
    super.initState();
    // Retrieve shared preferences stored values
    retrieveSharedPrefsValues();
  }

  void retrieveSharedPrefsValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('selectedSource');
    int? intValue = prefs.getInt('duration');

    // Send shared preferences stored values to background task
    sendValuesToBackgroundTask(stringValue!, intValue!);
  }

  void sendValuesToBackgroundTask(String stringValue, int intValue) {
    const platform = MethodChannel('com.example.wallpaper_verse/bgtsk');
    try {
      platform.invokeMethod('startBackgroundTask', {
        'stringValue': stringValue,
        'intValue': intValue,
      });
    } on PlatformException catch (e) {
      print("Failed to start background task: '${e.message}'.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainHome(),
    );
  }
}
