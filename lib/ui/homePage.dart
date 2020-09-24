import 'package:flutter/material.dart';
import 'package:prefecthabittracer/models/destinationBottomNavigation.dart';
import 'package:prefecthabittracer/services/Authf.dart';
import 'package:prefecthabittracer/shared/Drawer.dart';
import 'destinationViewBottomNavigations.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _selectedBottomNavigationIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  void _onBottomNavigationItemTapped(int index) {
    setState(() {
      _selectedBottomNavigationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        //leading: Drawer(child: prefix0.IconButton(icon: Icon(Icons.navigation), onPressed: null),),
        centerTitle: true,
        title: _selectedBottomNavigationIndex == 0
            ? Text(
                'Daily Tasks',
                style: TextStyle(color: Colors.black),
              )
            : _selectedBottomNavigationIndex == 1
                ? Text(
                    'Weekly Tasks',
                    style: TextStyle(color: Colors.black),
                  )
                : _selectedBottomNavigationIndex == 2
                    ? Text(
                        '90 Day Challange',
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        'Feedback',
                        style: TextStyle(color: Colors.black),
                      ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Image.asset(
        //       'assets/signout.png',
        //       color: Colors.redAccent,
        //       height: 40,
        //     ),
        //     onPressed: () {
        //       AuthService().signOut();
        //     },
        //   )
        // ],
      ),
      drawer: Drawer(
        child: CustomDrawer(),
      ),
      body: IndexedStack(
        index: _selectedBottomNavigationIndex,
        children: allDestinations.map<Widget>((Destination destination) {
          return DestinationView(
            destination: destination,
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavigationIndex,
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        //showUnselectedLabels: true,

        onTap: _onBottomNavigationItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle,
                size: 18,
              ),
              title: Text(
                'Daily Tasks',
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
                size: 18,
              ),
              title: Text(
                'Weekly Tasks',
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
                size: 18,
              ),
              title: Text(
                '90 Days Habbit',
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.feedback,
                size: 18,
              ),
              title: Text(
                'Feedback',
              )),
        ],
      ),
    );
  }
}
