import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_verse/pages/register.dart';
import '../main_home.dart';
import '../widgets/app_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/login.php');
    var data = {'email': email, 'password': password};

    try {
      var response = await http.post(url, body: json.encode(data));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('Name', responseData['user_data']['name']);
          prefs.setString('email', email);
          prefs.setString('password', password);
          prefs.setString('id', responseData['user_data']['user_code'].toString());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainHome()),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color.fromRGBO(33, 33, 33, 1),
                title: Text('Login Failed'),
                content: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          responseData['message'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Failed to connect to the server.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(33, 33, 33, 1),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 50),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // Add the form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    child: Image.asset(
                      'assets/app_icon/app_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Container(
                      color: Color.fromRGBO(33, 33, 33, 1),
                      child: TextFormField(
                        key: Key('email'),
                        controller: _emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          suffixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required.';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Container(
                      color: Color.fromRGBO(33, 33, 33, 1),
                      child: TextFormField(
                        key: Key('password'),
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          suffixIcon: Icon(
                            Icons.password,
                            color: Colors.white,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required.';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (!_isLoading) {
                                _login();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Log In',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CircularProgressIndicator(),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'New to the app ?',
                                  style: TextStyle(fontSize: 15, color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                                  },
                                  child: Text(
                                    ' Register Now !',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              'X wallpaper auto ®',
                              style: TextStyle(fontSize: 15, color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
