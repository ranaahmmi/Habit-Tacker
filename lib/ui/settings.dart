import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () async {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text('Logout'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
