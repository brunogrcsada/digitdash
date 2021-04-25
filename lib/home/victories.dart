//Packages
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:decorated_icon/decorated_icon.dart';

//Components
import '../levels.dart';
import '../extensions/colorFilter.dart';
import '../extensions/darkenColor.dart';

class Victories extends StatefulWidget {
  Victories({Key? key}) : super(key: key);

  @override
  _VictoriesState createState() => _VictoriesState();
}

class _VictoriesState extends State<Victories> {
  List<String>? levelState;
  List<String>? scoreState;
  List<String>? starState;

  void getProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      levelState = prefs.getStringList('levels');
      scoreState = prefs.getStringList('scores');
      starState = prefs.getStringList('stars');
    });
  }

  void resetProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList('levels', ["true", "false", "false", "false"]);
    prefs.setStringList('scores', ["0", "0", "0", "0"]);
    prefs.setStringList('stars', ["0", "0", "0", "0"]);

    getProgress();
  }

  @override
  void initState() {
    super.initState();
    getProgress();
  }

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
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 40,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text("Progress",
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
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 120),
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 26),
                  scrollDirection: Axis.horizontal,
                  itemCount: levels.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == levels.length - 1) {
                      return Container();
                    } else {
                      return AspectRatio(
                        aspectRatio: 1,
                        child: new Container(
                          margin: const EdgeInsets.all(10),
                          decoration: new BoxDecoration(
                            color: levelState?[index + 1] != "false"
                                ? levels[index].background
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: ColorFiltered(
                              colorFilter: levelState?[index + 1] != "false"
                                  ? ColorFilter.mode(
                                      Colors.transparent,
                                      BlendMode.multiply,
                                    )
                                  : colorFilter,
                              child: SvgPicture.asset(
                                  'assets/' + levels[index].trophy,
                                  width: 56,
                                  semanticsLabel: 'Logo'),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: levels.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == levels.length - 1) {
                        return Container();
                      } else {
                        return Container(
                          margin: const EdgeInsets.all(12),
                          decoration: new BoxDecoration(
                            color: levels[index].background,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 110,
                          child: new Row(children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    margin: const EdgeInsets.all(24),
                                    decoration: new BoxDecoration(
                                      color: darkenColor(
                                          levels[index].background, 1.0, -20),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        (index + 1).toString(),
                                        style: new TextStyle(
                                            fontSize: 35,
                                            color: levels[index].foreground,
                                            fontFamily: 'Mansalva'),
                                      ),
                                    ),
                                  )),
                            ),
                            if (scoreState != null)
                              Text(
                                "Max: " + scoreState![index],
                                style: new TextStyle(
                                    fontFamily: "IndieFlower",
                                    fontSize: 30,
                                    color: darkenColor(
                                        levels[index].foreground, 1.0, 40)),
                              ),
                            Expanded(
                              child: Container(),
                            ),
                            if (starState != null)
                              Container(
                                  margin: const EdgeInsets.only(right: 21),
                                  child: Row(
                                    children: List.generate(3, (starIndex) {
                                      if (index + 1 <=
                                          int.parse(
                                              starState![index].toString())) {
                                        return DecoratedIcon(
                                          Icons.star_rounded,
                                          color: Color.fromRGBO(255, 212, 1, 1),
                                          size: 30.0,
                                          shadows: [
                                            BoxShadow(
                                              blurRadius: 5.0,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 200),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return DecoratedIcon(
                                          Icons.star_outline_rounded,
                                          color: Colors.white,
                                          size: 30.0,
                                          shadows: [
                                            BoxShadow(
                                              blurRadius: 5.0,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 200),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                                  ))
                          ]),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
