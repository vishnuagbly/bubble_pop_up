import 'package:bubble_pop_up/bubble_pop_up.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PopupScope(
              builder: (_) => Stack(
                    children: [
                      Positioned(
                        top: 200,
                        left: 200,
                        child: BubblePopUp(
                          config: BubblePopUpConfig(
                            baseAnchor: Alignment.topCenter,
                            popUpAnchor: Alignment.bottomLeft,
                            arrowDirection: ArrowDirection.down,
                            childBorderRadius: BorderRadius.circular(10),
                          ),
                          popUpColor: Colors.green,
                          popUp: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  )),
        ),
      ),
    );
  }
}
