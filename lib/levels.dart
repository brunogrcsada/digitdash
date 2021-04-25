import 'package:flutter/material.dart';

class Level {
  Color background;
  Color foreground;
  GlobalKey globalKey;
  List curve;

  int time;
  int targetScore;
  int targetQuestions;
  int questionNumber;

  String trophy;
  String trophyName;

  Level(
      this.background,
      this.foreground,
      this.globalKey,
      this.curve,
      this.time,
      this.targetScore,
      this.targetQuestions,
      this.questionNumber,
      this.trophy,
      this.trophyName);
}

List<Level> levels = [
  Level(
      Color.fromRGBO(129, 208, 213, 1),
      Color.fromRGBO(75, 129, 133, 1),
      GlobalKey(),
      [300.0, 30.0, 420.0, 130.0],
      0,
      300,
      9,
      10,
      "calculator-32229.svg",
      "Learner's Trophy"),
  Level(
      Color.fromRGBO(213, 129, 161, 1),
      Color.fromRGBO(148, 89, 111, 1),
      GlobalKey(),
      [230.0, 500.0, 110.0, 340.0],
      20,
      300,
      8,
      10,
      "divide-40654.svg",
      "Division Master"),
  Level(
      Color.fromRGBO(129, 213, 173, 1),
      Color.fromRGBO(97, 139, 119, 1),
      GlobalKey(),
      [160.0, 790.0, 250.0, 550.0],
      10,
      300,
      7,
      10,
      "achievement-1294003.svg",
      "Winner's Trophy"),
  Level(
      Color.fromRGBO(129, 213, 173, 1),
      Color.fromRGBO(97, 139, 119, 1),
      GlobalKey(),
      [200.0, 200.0, 200.0, 200.0],
      5,
      300,
      6,
      10,
      "achievement-1294003.svg",
      "Winner's Trophy"),
];
