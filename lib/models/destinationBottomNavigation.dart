import 'package:flutter/material.dart';

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Daily Tasks', Icons.home, Colors.teal),
  Destination('Weekly Tasks', Icons.business, Colors.cyan),
  Destination('90 Day Habbit', Icons.school, Colors.orange),
  Destination('Feedback', Icons.school, Colors.orange),
  // Destination('Flight', Icons.flight, Colors.blue)
];