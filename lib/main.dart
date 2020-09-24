import 'package:flutter/material.dart';
import 'package:prefecthabittracer/services/Authf.dart';
import 'package:prefecthabittracer/ui/Splash_Screen.dart';
import 'package:prefecthabittracer/ui/wrapper.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService()
          .user, //accessing the user stream to decide if user should be shown the hom page or the login page
      child: new MaterialApp(
          title: 'TheGorgeousLogin',
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen()),
    );
  }
}
