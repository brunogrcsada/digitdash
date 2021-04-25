//Packages
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Components
import '../extensions/position.dart';
import '../levels.dart';
import '../../gameplay/preview.dart';
import '../gameplay/question.dart';
import '../extensions/colorFilter.dart';

import 'circles.dart';
import 'path.dart';
import 'victories.dart';

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

  ScaleRoute({required this.page, RouteSettings? settings})
      : super(
          settings: settings,
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

  GlobalKey learnerTrophy = GlobalKey();
  List<double> learnerPositions = [0.0, 0.0];
  int currentTutorial = 0;

  _LevelsState({this.tutorial, required this.unlockState});

  List<String> tutorials = [
    "Each circle is a level in the game",
    "Earn trophies by completing \nlevels!",
    "View high\n scores and\n trophies earned!",
    "Answer a maths question the keypad"
  ];

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _obtainPosition());
    updateProgress();
    super.initState();
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

    learnerPositions = [
      learnerTrophy.widgetCoordinates[0],
      learnerTrophy.widgetCoordinates[1]
    ];

    setState(() {
      levelPositions = levelPositions;
      learnerPositions = [
        learnerTrophy.widgetCoordinates[0],
        learnerTrophy.widgetCoordinates[1]
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                            margin: const EdgeInsets.only(right: 2),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(ScaleRoute(
                                    page: Victories(),
                                    settings: RouteSettings(name: 'Victories'),
                                  ))
                                      .then((value) {
                                    updateProgress();
                                    setState(() {});
                                  });
                                },
                                child: Icon(Icons.emoji_events_outlined,
                                    size: tutorial! ? 55 : 40)),
                          )
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
                                      startOffset: [
                                        Offset(0, 0),
                                        Offset(0, 0)
                                      ]),
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
                                        Navigator.of(context)
                                            .push(ScaleRoute(
                                          page: LevelPreview(
                                            level: levels[index],
                                            levelIndex: index,
                                          ),
                                          settings: RouteSettings(
                                              name: 'LevelScreen'),
                                        ))
                                            .then((value) {
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
                                      key: index == 0 ? learnerTrophy : null,
                                      child: GestureDetector(
                                          onTap: () {
                                            print("trophy");
                                          },
                                          child: Transform.rotate(
                                            angle: -19.4,
                                            child: ColorFiltered(
                                              colorFilter:
                                                  unlockState[index + 1] ==
                                                          "true"
                                                      ? ColorFilter.mode(
                                                          Colors.transparent,
                                                          BlendMode.multiply,
                                                        )
                                                      : colorFilter,
                                              child: SvgPicture.asset(
                                                  'assets/' +
                                                      levels[index].trophy,
                                                  width: 56,
                                                  semanticsLabel: 'Trophie'),
                                            ),
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
            if (tutorial!)
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Color.fromRGBO(104, 104, 104, 20), BlendMode.srcOut),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          backgroundBlendMode: BlendMode.dstOut),
                    ),
                    Positioned(
                      top: currentTutorial == 0
                          ? levelPositions[0][1] - 70
                          : currentTutorial == 1
                              ? learnerPositions[1] - 88
                              : currentTutorial == 2
                                  ? -50.0
                                  : 0.0,
                      left: currentTutorial == 0
                          ? levelPositions[0][0]
                          : currentTutorial == 1
                              ? learnerPositions[0] - 23
                              : currentTutorial == 2
                                  ? null
                                  : 0.0,
                      right: currentTutorial == 2 ? 0.0 : null,
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
            if (tutorial!)
              Positioned(
                top: currentTutorial == 0
                    ? levelPositions[0][1] + 130
                    : currentTutorial == 1
                        ? learnerPositions[1] + 130
                        : currentTutorial == 2
                            ? 175
                            : 200,
                left: currentTutorial == 0
                    ? levelPositions[0][0]
                    : currentTutorial == 1
                        ? learnerPositions[0] - 150
                        : currentTutorial == 2
                            ? 110
                            : 10,
                child: Container(
                  width: currentTutorial == 0 ? 240 : 280,
                  child: Text(
                    tutorials[currentTutorial],
                    style: new TextStyle(
                        fontFamily: 'IndieFlower',
                        fontSize: 37,
                        color: Colors.white),
                  ),
                ),
              ),
            if (tutorial!)
              Positioned(
                  top: currentTutorial == 0
                      ? levelPositions[0][1] + 230
                      : currentTutorial == 1
                          ? learnerPositions[1] + 230
                          : currentTutorial == 2
                              ? 170
                              : 10,
                  left: currentTutorial == 0
                      ? levelPositions[0][0] + 200
                      : currentTutorial == 1
                          ? learnerPositions[0] + 50
                          : currentTutorial == 2
                              ? null
                              : 20,
                  right: currentTutorial == 2 ? 20 : null,
                  child: GestureDetector(
                    onTap: () {
                      if (currentTutorial == 2) {
                        setState(() {
                          tutorial = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Question(
                                    tutorial: true,
                                    level: levels[0],
                                    levelIndex: 0,
                                  )),
                        );
                      } else {
                        setState(() {
                          currentTutorial++;
                        });
                      }
                    },
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
                    ),
                  )),
            if (tutorial!)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 350,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/bird-616803.png',
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.bottomCenter,
                  ),
                  transform: Matrix4.translationValues(30, 30.0, 0.0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
