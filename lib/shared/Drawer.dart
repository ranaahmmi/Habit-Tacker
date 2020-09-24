import 'package:flutter/material.dart';
import 'package:prefecthabittracer/services/Authf.dart';
import 'package:prefecthabittracer/ui/Edit_Profile.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            ClipRRect(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
                child: Image.asset(
                  'assets/landlogo.png',
                  fit: BoxFit.cover,
                )).py24(),
            Divider(
              height: 1,
              color: Colors.grey,
            ).px8(),
            ListTile(
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => EditProfile()));
              },
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ).px8(),
            ListTile(
              title: Text('About'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Rate Us'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Share'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Privacy Policy'),
              onTap: () {},
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ).px8(),
            ListTile(
              title: Text('Signout'),
              onTap: () async {
                await AuthService().signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
