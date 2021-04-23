//Packages
import 'package:flutter/material.dart';

//Components
import '../levels.dart';

class Question extends StatefulWidget {
  final Level level;

  Question({Key? key, required this.level}) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState(level: this.level);
}

class _QuestionState extends State<Question> {
  
  final Level? level;
  _QuestionState({this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: level?.background,
      body: SafeArea(
      child: Column(
        children: [
          Row(children: [
            Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            Text(
              "Level 1",
              style: new TextStyle(fontSize: 40),
            ),
          ]),
          Row(
            children: [Icon(Icons.star)],
          ),
          Container(
            margin: const EdgeInsets.only(top: 40, bottom: 40),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Color.fromRGBO(119, 62, 232, 1),
              shape: BoxShape.rectangle,
              boxShadow: [
                new BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(children: [
              Icon(
                Icons.timer,
                size: 30,
              ),
              Text(
                "No Limit"
              )
            ],),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40, bottom: 40),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Color.fromRGBO(119, 62, 232, 1),
              shape: BoxShape.rectangle,
              boxShadow: [
                new BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(children: [
              Icon(
                Icons.arrow_circle_up,
                size: 30,
              ),
              Text(
                "9/10"
              )
            ],),
          ),
        ],
      )),
    );
  }
}
