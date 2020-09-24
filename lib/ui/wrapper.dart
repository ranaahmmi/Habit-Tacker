import 'package:flutter/material.dart';
import 'package:prefecthabittracer/models/user.dart';
import 'package:provider/provider.dart';

import 'homePage.dart';
import 'login_page.dart';

String myId;

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(
        context); //accessing user data from provider, after specifying type of data "USER" so that it knows which stream to listen

    if (user != null) {
      myId = user.uid;
      return MyHomePage();
    } else {
      return LoginPage();
    }
  }
}
