//Packages
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Components
import '../levels.dart';
import '../extensions/colorFilter.dart';

class Victories extends StatefulWidget {
  Victories({Key? key}) : super(key: key);

  @override
  _VictoriesState createState() => _VictoriesState();
}

class _VictoriesState extends State<Victories> {
  List<String>? levelState;

  @override
  void initState() {
    getProgress();
    super.initState();
  }

  void getProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      levelState = prefs.getStringList('levels');
    });
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
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 120),
                child: Expanded(
                  flex: 1,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 20),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
