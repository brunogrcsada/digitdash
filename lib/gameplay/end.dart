//Packages
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Components
import '../levels.dart';
import '../extensions/darkenColor.dart';
import '../extensions/colorFilter.dart';

class LevelEnd extends StatefulWidget {
  final int correctAnswers;
  final int score;
  final Level level;
  final int levelIndex;

  LevelEnd(
      {Key? key,
      required this.correctAnswers,
      required this.level,
      required this.levelIndex,
      required this.score})
      : super(key: key);

  @override
  _LevelEndState createState() => _LevelEndState(
      correctAnswers: this.correctAnswers,
      level: this.level,
      levelIndex: this.levelIndex,
      score: this.score);
}

class _LevelEndState extends State<LevelEnd> {
  int correctAnswers;
  Level level;
  int score;
  int levelIndex;

  _LevelEndState(
      {required this.correctAnswers,
      required this.level,
      required this.score,
      required this.levelIndex});

  List<String>? levels;
  List<String>? scores;

  unlockLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    levels = prefs.getStringList('levels');
    scores = prefs.getStringList('scores');

    levels![levelIndex + 1] = "true";

    if (score > (int.parse(scores![levelIndex]))) {
      scores![levelIndex] = score.toString();
    }

    prefs.setStringList('levels', levels!);
    prefs.setStringList('scores', scores!);
  }

  @override
  void initState() {
    if (correctAnswers >= level.targetQuestions) {
      unlockLevel();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: level.background,
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 50, bottom: 20),
              child: ColorFiltered(
                colorFilter: correctAnswers >= level.targetQuestions
                    ? ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.multiply,
                      )
                    : colorFilter,
                child: SvgPicture.asset('assets/trophy.svg',
                    width: 56, semanticsLabel: 'Trophie'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(correctAnswers.toString() + "/10",
                  style: new TextStyle(
                    fontSize: 80,
                    fontFamily: "Mansalva",
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(5.0, 5.0),
                        blurRadius: 4.0,
                        color: Color.fromRGBO(0, 0, 0, 200),
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 50, right: 50),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  border: Border.all(width: 1, color: level.foreground)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    child: ColorFiltered(
                        colorFilter: correctAnswers >= level.targetQuestions
                            ? ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.multiply,
                              )
                            : colorFilter,
                        child: SvgPicture.asset('assets/' + level.trophy,
                            width: 90, semanticsLabel: 'Logo')),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                        correctAnswers >= level.targetQuestions
                            ? level.trophyName
                            : level.targetQuestions.toString() +
                                "/10" +
                                " for a trophy",
                        style: new TextStyle(
                            fontSize: 34, fontFamily: 'IndieFlower')),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).popUntil((route) {
                  return route.settings.name == 'HomePage';
                });
              },
              child: Container(
                constraints: BoxConstraints(maxWidth: 300),
                decoration: BoxDecoration(
                  color: darkenColor(level.background, 1.0, 24),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                margin: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/15238257771553771426.svg',
                      semanticsLabel: 'Logo',
                      width: 70,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30, right: 30),
                      child: Center(
                        child: Text(
                          "Levels",
                          style: new TextStyle(
                              fontSize: 50,
                              fontFamily: "IndieFlower",
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).popUntil((route) {
                      return route.settings.name == 'LevelScreen';
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        child: Text(
                          "Retry!",
                          style: new TextStyle(
                              fontSize: 40,
                              fontFamily: "IndieFlower",
                              color: darkenColor(level.foreground, 1.0, 40)),
                        ),
                      ))),
            ),
          )
        ]),
      ),
    );
  }
}
