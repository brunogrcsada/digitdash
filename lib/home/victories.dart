//Packages
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//Components
import '../levels.dart';

class Victories extends StatefulWidget {
  Victories({Key? key}) : super(key: key);

  @override
  _VictoriesState createState() => _VictoriesState();
}

class _VictoriesState extends State<Victories> {
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
                    Image.asset('assets/logo.png', scale: 1.3),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text("Victories",
                          style: new TextStyle(
                              fontFamily: 'IndieFlower', fontSize: 35)),
                    ),
                    Expanded(child: Container()),
                    Icon(Icons.emoji_events_outlined, size: 40)
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 120),
                child: Expanded(
                  flex: 1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: levels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AspectRatio(
                        aspectRatio: 1,
                        child: new Container(
                          margin: const EdgeInsets.all(10),
                          decoration: new BoxDecoration(
                            color: levels[index].background,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: SvgPicture.asset(
                                'assets/' + levels[index].trophy,
                                width: 56,
                                semanticsLabel: 'Logo'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: levels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: new BoxDecoration(
                          color: levels[index].background,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: SvgPicture.asset(
                            'assets/' + levels[index].trophy,
                            width: 56,
                            semanticsLabel: 'Logo'),
                      );
                    },
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
