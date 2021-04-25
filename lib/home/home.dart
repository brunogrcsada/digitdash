//Packages
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Components
import '../extensions/position.dart';
import '../levels.dart';
import '../../gameplay/preview.dart';

import 'circles.dart';
import 'path.dart';
import 'victories.dart';
import 'tutorial.dart';

class Levels extends StatefulWidget {
  final bool tutorial;
  final List<String> unlockState;
  Levels({Key? key, required this.tutorial, required this.unlockState})
      : super(key: key);

  @override
  _LevelsState createState() =>
      _LevelsState(tutorial: this.tutorial, unlockState: this.unlockState);
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;

  ScaleRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ),
        );
}

class _LevelsState extends State<Levels> {
  bool? tutorial;
  List<String> unlockState;
  List<List<double>> levelPositions =
      new List<List<double>>.generate(levels.length, (i) => [0.0, 0.0]);

  _LevelsState({this.tutorial, required this.unlockState});

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _obtainPosition());
    updateProgress();
    super.initState();
  }

  void resetProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList('levels', ["true", "false", "false", "false"]);
    prefs.setStringList('scores', ["0", "0", "0", "0"]);
    prefs.setStringList('starts', ["0", "0", "0", "0"]);

    updateProgress();
  }

  void updateProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      unlockState = prefs.getStringList('levels') ?? [""];
    });
  }

  void _obtainPosition() {
    for (var i = 0; i < levels.length; i++) {
      levelPositions[i] = [
        levels[i].globalKey.widgetCoordinates[0],
        levels[i].globalKey.widgetCoordinates[1]
      ];
    }

    setState(() {
      levelPositions = levelPositions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 252, 223, 1),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Image.asset('assets/logo.png', scale: 1.3),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text("Levels",
                              style: new TextStyle(
                                  fontFamily: 'IndieFlower', fontSize: 35)),
                        ),
                        Expanded(child: Container()),
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  resetProgress();
                                });
                              },
                              child: Icon(Icons.restart_alt, size: 40)),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Victories()),
                              );
                            },
                            child: Icon(Icons.emoji_events_outlined, size: 40))
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Stack(children: [
                        Column(
                          children: List.generate(levels.length, (index) {
                            if (index != levels.length - 1) {
                              return CustomPaint(
                                painter: LevelPath(
                                    level: levels[index],
                                    levelPosition: levelPositions[index],
                                    nextPosition: levelPositions[index + 1],
                                    valueSet: false,
                                    unlockStatus: index == levels.length
                                        ? "last"
                                        : unlockState[index + 1],
                                    startOffset: [Offset(0, 0), Offset(0, 0)]),
                                child: Container(),
                              );
                            } else
                              return Container();
                          }),
                        ),
                        Column(
                          children: List.generate(levels.length, (index) {
                            return Container(
                              alignment: index.isOdd
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              margin: index.isOdd
                                  ? EdgeInsets.only(right: 20)
                                  : null,
                              padding: const EdgeInsets.all(63),
                              child: Container(
                                key: levels[index].globalKey,
                                child: GestureDetector(
                                  onTap: () {
                                    if (unlockState[index] == "false") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Oopsies! Unlock level ' +
                                                      (index).toString() +
                                                      ' first!')));
                                    } else {
                                      Navigator.push(
                                          context,
                                          ScaleRoute(
                                            page: LevelPreview(
                                              level: levels[index],
                                              levelIndex: index,
                                            ),
                                          )).then((value) {
                                        updateProgress();
                                        setState(() {});
                                      });
                                    }
                                  },
                                  child: LevelCircle(
                                    level: index + 1,
                                    background: unlockState[index] == "true"
                                        ? levels[index].background
                                        : Color.fromRGBO(223, 223, 223, 1),
                                    foreground: unlockState[index] == "true"
                                        ? levels[index].foreground
                                        : Color.fromRGBO(114, 114, 114, 1),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: List.generate(levels.length, (index) {
                              if (index == levels.length - 1) {
                                return Container();
                              } else {
                                return Container(
                                  alignment: index.isEven
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  margin: index.isEven
                                      ? EdgeInsets.only(right: 40, bottom: 10)
                                      : EdgeInsets.only(top: 20),
                                  padding: const EdgeInsets.all(80),
                                  child: Container(
                                    child: GestureDetector(
                                        onTap: () {
                                          print("trophy");
                                        },
                                        child: Transform.rotate(
                                          angle: -19.4,
                                          child: SvgPicture.asset(
                                              'assets/' + levels[index].trophy,
                                              width: 56,
                                              semanticsLabel: 'Logo'),
                                        )),
                                  ),
                                );
                              }
                            }),
                          ),
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (tutorial!) TutorialOverlay(levelPosition: levelPositions[0])
        ],
      ),
    );
  }
}
