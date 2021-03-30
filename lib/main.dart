import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter  Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  SignIn(String email, password) async {
    Map data = {
      'email': email,
      'password': password,
    };
    var jsonData = null;
    SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    // var response = await http.post(Uri.http('my.api.mockaroo.com/login.json?key=ce750120','') ,body: data);
    var response = await http.post(
      Uri.parse('https://my.api.mockaroo.com/login.json?key=ce750120'),
      body: data,
    );
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        _isLoading = false;
        sharedpreferences.setString("token", jsonData('token'));
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      });
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login '),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'email',
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'password',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      SignIn(emailController.text, passwordController.text);
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
      ),
    );
  }
}
