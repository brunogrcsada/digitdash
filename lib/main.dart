//Packages
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

//Components
import 'home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digit Dash',
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<String>? unlockState;

  _createStorageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    unlockState = prefs.getStringList('levels') ?? [""];

    setState(() {
        if (unlockState![0] == "") {
            prefs.setStringList('levels', ["true", "false", "false", "false"]);
            prefs.setStringList('scores', ["0", "0", "0", "0"]);
            prefs.setStringList('stars', ["0", "0", "0", "0"]);
          }

        
        unlockState = ["true", "false", "false", "false"];
    });
  }

  @override
  void initState() {
    _createStorageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 252, 223, 1),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 35),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 4,
                  child: SvgPicture.asset('assets/time-2020934.svg',
                      semanticsLabel: 'Logo')),
              Expanded(
                  flex: 7,
                  child: Container(
                    margin: const EdgeInsets.only(right: 50),
                    child: SvgPicture.asset('assets/appName.svg',
                        semanticsLabel: 'Name'),
                  )),
              Expanded(
                  flex: 3,
                  child: Center(
                      child: Container(
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(98, 98, 98, 40),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) {
                                  return Levels(
                                    tutorial: false,
                                    unlockState: unlockState!,
                                  );
                                },
                                settings: RouteSettings(name: 'HomePage'),
                              ));
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              margin: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(197, 146, 146, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    "✘",
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text("Tutorial?",
                              style: new TextStyle(
                                  fontFamily: 'IndieFlower',
                                  fontSize: 35,
                                  color: Colors.white)),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) {
                                  return Levels(
                                    tutorial: true,
                                    unlockState: unlockState!,
                                  );
                                },
                                settings: RouteSettings(name: 'HomePage'),
                              ));
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              margin: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(126, 200, 124, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Center(
                                  child: Text(
                                "✔",
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 30),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    transform: Matrix4.translationValues(0, 15.0, 0.0),
                  ))),
              Expanded(
                  flex: 9,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/bird-616803.png',
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.bottomCenter,
                    ),
                    transform: Matrix4.translationValues(30, 30.0, 0.0),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
