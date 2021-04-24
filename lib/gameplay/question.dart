//Packages
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:vibration/vibration.dart';
import 'dart:math';

//Components
import '../levels.dart';

class Question extends StatefulWidget {
  final Level? level;

  Question({Key? key, @required this.level}) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState(level: this.level);
}

class _QuestionState extends State<Question> {
  final Level? level;
  _QuestionState({this.level});

  void createAnswer(){

    Random random = new Random();

    int firstNumber = random.nextInt(90) + 10;
    int secondNumber = random.nextInt(90) + 10;

  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: level?.background,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 30),
                    child: Row(
                      children: [
                        Flexible(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Flexible(
                              flex: 1,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: DottedDecoration(
                                      shape: Shape.circle,
                                      dash: <int>[18, 18],
                                      color: level!.foreground,
                                      strokeWidth: 4),
                                  width: double.infinity,
                                  height: 100.0,
                                  child: Center(
                                    child: Text(
                                      "1",
                                      style: new TextStyle(
                                          fontSize: 55,
                                          color: level?.foreground,
                                          fontFamily: 'Mansalva'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.only(left: 50),
                            child: Column(
                              children: [
                                Text(
                                  "Score: 500",
                                  style: new TextStyle(
                                      fontFamily: 'Mansalva', fontSize: 25),
                                ),
                                Stack(children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(100, 166, 170, 1),
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No Limit",
                                        style: new TextStyle(
                                            fontFamily: "Mansalva",
                                            color: Colors.white,
                                            fontSize: 24),
                                      ),
                                    ),
                                  ),
                                ])
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(
                      "2 x 3",
                      style:
                          new TextStyle(fontFamily: "Mansalva", fontSize: 90),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(100, 166, 170, 1),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Center(
                      child: Text(
                        "6",
                        style: new TextStyle(
                          fontFamily: "Mansalva",
                          fontSize: 35,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
                //todo: Ensure that this is fixed at the bottom of the page:
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: new LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return new GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: new ScrollController(keepScrollOffset: false),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: (constraints.maxWidth / 3) /
                        (constraints.maxHeight / 4),
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 0.0,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return Expanded(
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: new GridTile(
                          child: Container(
                            margin: const EdgeInsets.all(9),
                            child: new Center(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: GestureDetector(
                                  onTap: () async{

                                    var vibration = await Vibration?.hasCustomVibrationsSupport();

                                    if (vibration == true) {
                                        Vibration.vibrate(duration: 10, intensities: [1, 1]);
                                    } else {
                                        Vibration.vibrate();
}
                                  },
                                                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Color.fromRGBO(100, 166, 170, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: Center(
                                      child: new Text(
                                        (index + 1).toString(),
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Mansalva",
                                            fontSize: 45),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      )),
    );
  }
}
