import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:velocity_x/velocity_x.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/landlogo.png',
              width: 280,
            ),
            HeightBox(50),
            SpinKitChasingDots(
              color: Colors.green,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
