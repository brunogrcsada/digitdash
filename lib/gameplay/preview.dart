//Packages
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//Components
import '../levels.dart';
import 'question.dart';

class LevelPreview extends StatefulWidget {
  final Level level;

  LevelPreview({Key? key, required this.level}) : super(key: key);

  @override
  _LevelPreviewState createState() => _LevelPreviewState(level: this.level);
}

class _LevelPreviewState extends State<LevelPreview> {
  final Level? level;
  _LevelPreviewState({this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: level?.background,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
            top: -250.0,
            right: 100.0,
            left: -280.0,
            child: SvgPicture.asset("assets/tree-2750366.svg",
                color: Color.fromRGBO(77, 186, 193, 1)),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                  Text(
                    "Level 1",
                    style: new TextStyle(fontFamily: 'Mansalva', fontSize: 60),
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(top: 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      size: 50,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      size: 50,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      size: 50,
                      color: Colors.yellow,
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 250),
                    margin: const EdgeInsets.only(top: 40, bottom: 40),
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(
                      color: level?.background,
                      shape: BoxShape.rectangle,
                      border: Border.all(
                          color: Color.fromRGBO(3, 161, 171, 1), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 40,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "No Limit",
                                style: new TextStyle(
                                    fontFamily: "Mansalva",
                                    fontSize: 35,
                                    color: Color.fromRGBO(66, 110, 119, 1)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 230),
                    margin: const EdgeInsets.only(top: 0, bottom: 40),
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(
                      color: level?.background,
                      shape: BoxShape.rectangle,
                      border: Border.all(
                          color: Color.fromRGBO(3, 161, 171, 1), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_circle_up_rounded,
                            size: 40,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "9/10",
                                style: new TextStyle(
                                    fontFamily: "Mansalva",
                                    fontSize: 35,
                                    color: Color.fromRGBO(66, 110, 119, 1)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Question(
                                  level: level,
                                )),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 80),
                      constraints: BoxConstraints(maxWidth: 230),
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(92, 188, 194, 1),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left: 35, right: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.gamepad,
                              size: 40,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Play",
                                  style: new TextStyle(
                                      fontFamily: "IndieFlower",
                                      fontSize: 40,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
