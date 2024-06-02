import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_verse/pages/home.dart';
import 'dart:convert';
import 'package:wallpaper_verse/pages/login.dart';
import 'package:wallpaper_verse/main_home.dart';
import 'package:wallpaper_verse/pages/slideshow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Use SplashScreen as the initial route
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

 Future<void> checkLoginStatus()  async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');


    if (email != null && password != null) {
      var url = Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/accountcheck.php');
      var data = {'email': email, 'password': password};

      var response = await http.post(url, body: json.encode(data));
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          prefs.setString('id', responseData['user_code'].toString());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainHome()),
          );
          return;
        }
      }
    }

    // User is not logged in, navigate to LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  } catch (e) {
    print('Error checking login status: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 33, 33, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_icon/app_icon.png',
              height: 100, // Adjust the height as needed
              width: 100, // Adjust the width as needed
            ),
            SizedBox(height: 20), // Add some space between logo and loading ring
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

}
