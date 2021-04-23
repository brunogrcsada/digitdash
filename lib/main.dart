//Packages
import 'package:flutter/material.dart';

//Components
import 'home/circles.dart';
import 'levels.dart';
import 'home/path.dart';
import '../gameplay/preview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digit Dash',
      home: Levels(),
    );
  }
}

class Levels extends StatefulWidget {
  Levels({Key? key}) : super(key: key);

  @override
  _LevelsState createState() => _LevelsState();
}

class _LevelsState extends State<Levels> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 252, 223, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Image.asset('assets/logo.png', scale: 1.5),
                    Text("Levels",
                        style: new TextStyle(
                            fontFamily: 'IndieFlower', fontSize: 25)),
                    Expanded(child: Container()),
                    Icon(Icons.emoji_events_outlined, size: 40)
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(children: [
                      Column(
                        children: List.generate(levels.length, (index) {
                          if (index != levels.length - 1) {
                            return CustomPaint(
                              painter: LevelPath(
                                  level: levels[index],
                                  nextKey: levels[index + 1].globalKey,
                                  valueSet: false,
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
                            margin:
                                index.isOdd ? EdgeInsets.only(right: 20) : null,
                            padding: const EdgeInsets.all(60),
                            child: Container(
                              key: levels[index].globalKey,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LevelPreview(level: levels[index],)),
                                  );
                                },
                                child: LevelCircle(
                                  level: index + 1,
                                  background: levels[index].background,
                                  foreground: levels[index].foreground,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
