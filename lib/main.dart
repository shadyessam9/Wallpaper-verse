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

final MethodChannel _channel = MethodChannel('com.example.wallpaper_verse/unlock_task');

Future<void> activateUnlockTask() async {
  try {
    await _channel.invokeMethod('activateUnlockTask');
  } on PlatformException catch (e) {
    print("Failed to activate unlock task: '${e.message}'.");
  }
}

Future<void> deactivateUnlockTask() async {
  try {
    await _channel.invokeMethod('deactivateUnlockTask');
  } on PlatformException catch (e) {
    print("Failed to deactivate unlock task: '${e.message}'.");
  }
}

 static const platform = MethodChannel('com.example.wallpaper_verse/unlock_task');

  @override
  void initState() {
    super.initState();
    activateUnlockTask();
    platform.setMethodCallHandler((call) async {
      if (call.method == 'deviceUnlocked') {
        // Device is unlocked, print message
        print('Device unlocked');
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainHome(),
    );
  }
}
