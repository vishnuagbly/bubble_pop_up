import 'package:bubble_pop_up/bubble_pop_up.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: BubblePopUp(
            popUpColor: Colors.green,
            popUp: Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
            child: Container(
              height: 200,
              width: 200,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
