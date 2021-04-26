//Packages
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Components
import '../levels.dart';
import 'question.dart';
import '../extensions/darkenColor.dart';
import '../extensions/stars.dart';

class LevelPreview extends StatefulWidget {
  final Level level;
  final int levelIndex;

  LevelPreview({Key? key, required this.level, required this.levelIndex})
      : super(key: key);

  @override
  _LevelPreviewState createState() =>
      _LevelPreviewState(level: this.level, levelIndex: this.levelIndex);
}

class _LevelPreviewState extends State<LevelPreview> {
  final Level? level;
  final int levelIndex;
  List<String>? starState;

  _LevelPreviewState({this.level, required this.levelIndex});

  void getStars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      starState = prefs.getStringList('stars');
    });
  }

  @override
  void initState() {
    getStars();
    super.initState();
  }

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
                color: darkenColor(level!.background, 1.0, 30)),
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
                    child: Container(
                      margin: const EdgeInsets.only(right: 50),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 80),
                    child: Center(
                      child: Text(
                        "Level " + (levelIndex + 1).toString(),
                        style: new TextStyle(
                            fontFamily: 'Mansalva',
                            fontSize: 60,
                            color: darkenColor(level!.foreground, 1.0, 60)),
                      ),
                    ),
                  ),
                ]),
              ),
              if (starState != null)
                Container(
                    margin: const EdgeInsets.only(top: 60),
                    child: Stars(
                      starNumber: int.parse(starState![levelIndex]),
                    )),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 280),
                        margin: const EdgeInsets.only(top: 0, bottom: 40),
                        width: double.infinity,
                        height: 90,
                        decoration: BoxDecoration(
                          color: level?.background,
                          shape: BoxShape.rectangle,
                          border: Border.all(
                              color: darkenColor(level!.foreground, 1.0, 60),
                              width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/9031120521537856843.svg',
                                semanticsLabel: 'Logo',
                                width: 50,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    level!.time == 0
                                        ? "No Limit"
                                        : level!.time.toString() + " seconds",
                                    style: new TextStyle(
                                        fontFamily: "Mansalva",
                                        fontSize: 35,
                                        color: darkenColor(
                                            level!.foreground, 1.0, 60)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 210),
                        margin: const EdgeInsets.only(top: 0, bottom: 40),
                        width: double.infinity,
                        height: 90,
                        decoration: BoxDecoration(
                          color: level?.background,
                          shape: BoxShape.rectangle,
                          border: Border.all(
                              color: darkenColor(level!.foreground, 1.0, 60),
                              width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/3874760171579070430.svg',
                                semanticsLabel: 'Logo',
                                width: 50,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    level!.targetQuestions.toString() + "/10",
                                    style: new TextStyle(
                                        fontFamily: "Mansalva",
                                        fontSize: 35,
                                        color: darkenColor(
                                            level!.foreground, 1.0, 60)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Question(
                                  tutorial: false,
                                  level: level,
                                  levelIndex: levelIndex,
                                ), 
                                settings: RouteSettings(name: 'Gameplay')),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 80),
                      constraints: BoxConstraints(maxWidth: 230),
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: darkenColor(level!.background, 1.0, 30),
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
