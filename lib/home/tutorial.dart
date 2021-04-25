//Packages
import 'package:flutter/material.dart';

class TutorialOverlay extends StatefulWidget {
  final List<double> levelPosition;
  TutorialOverlay({Key? key, required this.levelPosition}) : super(key: key);

  @override
  _TutorialOverlayState createState() =>
      _TutorialOverlayState(levelPosition: this.levelPosition);
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  List<double> levelPosition;
  List<String> tutorials = [
    "Each circle is a level in the game",
    "Earn trophies by completing levels!",
    "View high scores and trophies earned!",
    "Answer a maths question the keypad"
  ];

  _TutorialOverlayState({required this.levelPosition});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
              Color.fromRGBO(104, 104, 104, 20), BlendMode.srcOut),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.black, backgroundBlendMode: BlendMode.dstOut),
              ),
              Positioned(
                top: levelPosition[1] - 70,
                left: levelPosition[0],
                child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 7,
                        color: Colors.red,
                        blurRadius: 10,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: levelPosition[1] + 130,
          left: levelPosition[0],
          child: Container(
            width: 240,
            child: Text(
              "Each circle is a level in the game",
              style: new TextStyle(
                  fontFamily: 'IndieFlower', fontSize: 37, color: Colors.white),
            ),
          ),
        ),
        Positioned(
            top: levelPosition[1] + 230,
            left: levelPosition[0] + 200,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(126, 200, 124, 1),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                  child: Text(
                "✔",
                style: new TextStyle(color: Colors.white, fontSize: 30),
              )),
            ))
      ],
    );
  }
}
