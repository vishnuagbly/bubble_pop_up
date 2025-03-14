import 'package:bubble_pop_up/bubble_pop_up.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const childBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.elliptical(30, 20),
    );

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PopupScope(
              builder: (_) => Stack(
                    children: [
                      Positioned(
                        top: 300,
                        left: 150,
                        child: BubblePopUp(
                          config: const BubblePopUpConfig(
                            baseAnchor: Alignment.topLeft,
                            popUpAnchor: Alignment.bottomRight,
                            arrowDirection: ArrowDirection.down,
                            childBorderRadius: childBorderRadius,
                          ),
                          popUpColor: Colors.green,
                          popUp: Container(
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: childBorderRadius,
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
