import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_auth/flutter_auth.dart';
 

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Example"),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AuthBuilder(
                      isSkipVisible: true,
                      onSkip: () {},
                      skipText: 'Skip',
                      baseUrl: 'https://api-lallantop-dev.mobiletak.com/',
                      onfailure: (message) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(message)));
                      },
                      footerWidget: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 30),
                        child: const Text("Terms and Conditions"),
                      ),
                      googleScopes: const [
                        'email',
                        'https://www.googleapis.com/auth/contacts.readonly',
                        'https://www.googleapis.com/auth/user.birthday.read',
                        'https://www.googleapis.com/auth/user.gender.read',
                        'https://www.googleapis.com/auth/user.phonenumbers.read',
                        'https://www.googleapis.com/auth/userinfo.profile'
                      ],
                      fbScopes:
                          "name,email,picture.width(200),first_name,last_name,birthday,friends,gender,link",
                      headerWidget: Container(
                        height: 66,
                        width: 66,
                        color: Colors.yellow,
                      ),
                      onloginSuccess: (userModel) {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => UserProfile(
                                  firstName: userModel.firstname ?? '',
                                  lastName: userModel.lastname ?? '',
                                  email: userModel.email,
                                  token: userModel.token ?? ''),
                            ));
                      },
                    );
                  },
                ));
              },
              child: const Text("Login Page"))),
    );
  }
}

class UserProfile extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String? email;
  final String token;

  const UserProfile(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.token,
      this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("first Name $firstName"),
            Text("last Name $lastName"),
            Text("email $email"),
          ],
        ),
      ),
    );
  }
}
