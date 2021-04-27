//Packages
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../extensions/darkenColor.dart';
import 'end.dart';
import 'dart:math';
import 'dart:async';

import '../extensions/position.dart';

//Components
import '../levels.dart';

class Question extends StatefulWidget {
  final Level? level;
  final int levelIndex;
  final bool tutorial;

  Question(
      {Key? key,
      @required this.level,
      required this.levelIndex,
      required this.tutorial})
      : super(key: key);

  @override
  _QuestionState createState() => _QuestionState(
      level: this.level, levelIndex: this.levelIndex, tutorial: this.tutorial);
}

class _QuestionState extends State<Question> {
  final Level? level;
  final int levelIndex;
  bool tutorial;
  AudioCache? _audioCache;
  bool? volume;

  String? previousCorrectAudio = "";
  String? previousIncorrectAudio = "";

  GlobalKey numberKey = GlobalKey();
  List<double> numberPositions = [0.0, 0.0];
  List<String> levelQuestions = [];

  _QuestionState(
      {this.level, required this.levelIndex, required this.tutorial});

  var correctAudio = [
    "genius.mp3",
    "impressive.mp3",
    "welldone.mp3",
    "brilliant.mp3",
    "splendid.mp3"
  ];

  var incorrectAudio = [
    "incorrect.mp3",
    "uhoh.mp3",
    "thatswrong.mp3",
    "oopsies.mp3"
  ];

  String userResponse = "";
  String question = "";

  int questionNumber = 1;
  int correctAnswers = 0;
  int answer = 0;
  int score = 0;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY)
    ..setReleaseMode(ReleaseMode.STOP);

  bool activeSnackbar = false;

  void resetGame() {
    setState(() {
      userResponse = "";
      question = "";
      questionNumber = 1;
      correctAnswers = 0;
      answer = 0;
      score = 0;

      createAnswer();
      if (level!.time != 0) {
        startTimer();
      }
      updateProgress();

      _audioCache = AudioCache(prefix: "assets/", fixedPlayer: audioPlayer);
    });
  }

  void createAnswer() {
    Random random = new Random();

    int firstNumber = 1 + random.nextInt(12 - 1);
    int questionOperator = random.nextInt(3);
    int secondNumber = 1 + random.nextInt(12 - 1);

    if (questionOperator == 2) {
      if (firstNumber == 1) {
        secondNumber = 1;
      } else {
        secondNumber = 1 + random.nextInt(firstNumber);
      }
    } else if (questionOperator == 1) {
      var numberList = [];
      for (var i = 1; i <= 12; i++) {
        if (firstNumber % i == 0) {
          numberList.add(i);
        }
      }

      secondNumber = numberList[random.nextInt(numberList.length)];
    }

    //todo: Make this neater (somehow):

    if (questionOperator == 0) {
      answer = firstNumber * secondNumber;
      question = firstNumber.toString() + " x " + secondNumber.toString();
    } else if (questionOperator == 1) {
      answer = firstNumber ~/ secondNumber;
      question = firstNumber.toString() + " ÷ " + secondNumber.toString();
    } else if (questionOperator == 2) {
      answer = firstNumber - secondNumber;
      question = firstNumber.toString() + " - " + secondNumber.toString();
    } else {
      answer = firstNumber + secondNumber;
      question = firstNumber.toString() + " + " + secondNumber.toString();
    }

    if(levelQuestions.contains(question)){
        createAnswer();
    } else{
        levelQuestions.add(question);
    }

  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Please enter a number!"),
      content: Text("Don't leave it empty..."),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void initState() {
    setState(() {
      volume = false;
      updateProgress();
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) => _obtainPosition());
    super.initState();
    createAnswer();
    if (level!.time != 0) {
      startTimer();
    }
    _audioCache = AudioCache(prefix: "assets/", fixedPlayer: audioPlayer);
  }

  void _obtainPosition() {
    setState(() {
      numberPositions = [
        numberKey.widgetCoordinates[0],
        numberKey.widgetCoordinates[1]
      ];
    });
  }

  void updateVolume(bool decision) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("volume", decision);
    volume = decision;
  }

  void updateProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      volume = prefs.getBool("volume");
    });
  }

  Timer? gameTimer;
  int? time;
  bool? timerStarted = false;

  void startTimer() {
    time = level!.time;

    gameTimer = new Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (time == 0) {
          setState(() {
            timer.cancel();
            score -= level!.maxScore ~/ 10;
            print("Incorrect");
            createAnswer();
            timerStarted = false;
            questionNumber++;
            _audioCache!.play('timesup.mp3');
            startTimer();
          });
        } else if (time == level!.time) {
          setState(() {
            timerStarted = true;
            time = time! - 1;
          });
        } else {
          setState(() {
            time = time! - 1;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    gameTimer!.cancel();
    super.dispose();
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                  constraints: BoxConstraints(maxHeight: 350),
                  decoration: BoxDecoration(
                      color: darkenColor(level!.background, 1.0, 40),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
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
                                color: darkenColor(level!.background, 1.0, 24),
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/15238257771553771426.svg',
                                    semanticsLabel: 'Logo',
                                    width: 70,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
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
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                updateVolume(!volume!);

                                Navigator.of(context).pop();
                              });
                            },
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 300),
                              decoration: BoxDecoration(
                                color: darkenColor(level!.background, 1.0, 24),
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Icon(
                                      volume!
                                          ? Icons.volume_off_rounded
                                          : Icons.volume_up_rounded,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  ),
                                  Container(
                                    width: 20,
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        volume! ? "Mute" : "Unmute",
                                        style: new TextStyle(
                                            fontSize: 46,
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (level!.time != 0) {
                                      gameTimer!.cancel();
                                  }

                                  timerStarted = false;

                                  resetGame();

                                  Navigator.of(context).pop();
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(3),
                                    child: Text(
                                      "Retry!",
                                      style: new TextStyle(
                                          fontSize: 40,
                                          fontFamily: "IndieFlower",
                                          color: darkenColor(
                                              level!.foreground, 1.0, 40)),
                                    ),
                                  ))),
                        )
                      ],
                    ),
                  )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: level?.background,
        body: Stack(
          children: [
            SafeArea(
                child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 20, right: 30),
                          child: Row(
                            children: [
                              Flexible(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: DottedDecoration(
                                          shape: Shape.circle,
                                          dash: <int>[18, 20],
                                          color: darkenColor(
                                              level!.foreground, 1.0, 25),
                                          strokeWidth: 4),
                                      width: double.infinity,
                                      height: 100.0,
                                      child: Center(
                                        child: Text(
                                          questionNumber.toString(),
                                          style: new TextStyle(
                                              fontSize: 55,
                                              color: darkenColor(
                                                  level!.foreground, 1.0, 25),
                                              fontFamily: 'Mansalva'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                  flex: 2,
                                  child: Container(
                                      margin: const EdgeInsets.only(left: 25),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  "Score: " + score.toString(),
                                                  style: new TextStyle(
                                                      fontFamily: 'Mansalva',
                                                      fontSize: 30,
                                                      color: darkenColor(
                                                          level!.foreground,
                                                          1.0,
                                                          30)),
                                                ),
                                              ),
                                              Expanded(child: Container()),
                                              GestureDetector(
                                                onTap: () {
                                                  createAlertDialog(context);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 2, right: 10),
                                                  child: Icon(
                                                    Icons.settings,
                                                    color: darkenColor(
                                                        level!.foreground,
                                                        1.0,
                                                        30),
                                                    size: 35,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Expanded(
                                            child: LayoutBuilder(builder:
                                                (BuildContext context,
                                                    BoxConstraints
                                                        constraints) {
                                              return Container(
                                                child: Stack(children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    decoration: BoxDecoration(
                                                      color: darkenColor(
                                                          level!.background,
                                                          1.0,
                                                          10),
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  25)),
                                                    ),
                                                  ),
                                                  AnimatedContainer(
                                                    width: timerStarted!
                                                        ? 0.1
                                                        : constraints.maxWidth,
                                                    duration: Duration(
                                                        seconds: timerStarted!
                                                            ? level!.time
                                                            : 0),
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: darkenColor(
                                                              level!.background,
                                                              1.0,
                                                              50),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          25)),
                                                        ),
                                                        child: ((() {
                                                          if (level!.time ==
                                                              0) {
                                                            return Center(
                                                              child: Text(
                                                                "No Limit",
                                                                style: new TextStyle(
                                                                    fontFamily:
                                                                        "Mansalva",
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        24),
                                                              ),
                                                            );
                                                          } else {
                                                            return Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20),
                                                                child: Text(
                                                                  time.toString(),
                                                                  style: new TextStyle(
                                                                      fontFamily:
                                                                          "Mansalva",
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          24),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        })())),
                                                  ),
                                                ]),
                                              );
                                            }),
                                          )
                                        ],
                                      ))),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 14),
                            child: Text(
                              question,
                              style: new TextStyle(
                                  fontFamily: "Mansalva",
                                  fontSize: 90,
                                  color:
                                      darkenColor(level!.foreground, 1.0, 50)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: UnconstrainedBox(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: darkenColor(level!.background, 1.0, 60),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Center(
                              child: Text(
                                userResponse.isEmpty
                                    ? "Your answer..."
                                    : userResponse,
                                style: new TextStyle(
                                    fontFamily: "Mansalva",
                                    fontSize: 35,
                                    color: Colors.white),
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
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: new LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return new GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        controller:
                            new ScrollController(keepScrollOffset: false),
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
                          return AspectRatio(
                            aspectRatio: 1.0,
                            child: new GridTile(
                              child: Container(
                                key: index == 0 ? numberKey : null,
                                margin: const EdgeInsets.all(9),
                                child: new Center(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (index == 9) {
                                          setState(() {
                                            userResponse = userResponse
                                                .replaceAll(RegExp(r'.$'), "");
                                          });
                                        } else if (index == 11) {

                                          List correctAudioList = correctAudio.toList();
                                          List incorrectAudioList = incorrectAudio.toList();

                                          correctAudioList.remove(previousCorrectAudio);
                                          incorrectAudioList.remove(previousIncorrectAudio);

                                          setState(() {
                                            if (userResponse.isEmpty) {
                                              showAlertDialog(context);
                                            } else {
                                              if (int.parse(userResponse) ==
                                                  answer) {

                                                
                                                correctAudioList.remove(previousIncorrectAudio);

                                                var audio = correctAudioList[Random()
                                                        .nextInt(correctAudioList
                                                            .length)];
                                                
                                                previousCorrectAudio = audio;

                                                _audioCache!.play(
                                                    audio,
                                                    volume:
                                                        volume! ? 1.0 : 0.0);

                                                score += level!.maxScore ~/ 10;
                                                correctAnswers++;
                                              } else {
                                                score -= level!.maxScore ~/ 10;

                                                 incorrectAudioList.remove(previousIncorrectAudio);

                                                 var audio = incorrectAudioList[Random()
                                                        .nextInt(incorrectAudioList
                                                            .length)];
                                                  
                                                  previousIncorrectAudio = audio;

                                                _audioCache!.play(
                                                    audio,
                                                    volume:
                                                        volume! ? 1.0 : 0.0);

                                              }

                                              if (questionNumber == 10) {
                                                if (level!.time != 0) {
                                                  gameTimer!.cancel();
                                                }

                                                timerStarted = false;

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LevelEnd(
                                                            correctAnswers:
                                                                correctAnswers,
                                                            level: level!,
                                                            score: score,
                                                            levelIndex:
                                                                levelIndex,
                                                          )),
                                                ).then((value) {
                                                  resetGame();
                                                });
                                                ;
                                              } else {
                                                userResponse = "";
                                                questionNumber++;
                                                if (level!.time != 0) {
                                                  gameTimer!.cancel();
                                                  timerStarted = false;
                                                  startTimer();
                                                }
                                                createAnswer();
                                              }
                                            }
                                          });
                                        } else {
                                          var vibration = await Vibration
                                              ?.hasCustomVibrationsSupport();

                                          if (vibration == true) {
                                            Vibration.vibrate(
                                                duration: 10,
                                                intensities: [1, 1]);
                                          } else {
                                            Vibration.vibrate();
                                          }

                                          setState(() {
                                            if (userResponse.length == 3) {
                                              if (activeSnackbar == false) {
                                                activeSnackbar = true;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        content: Text(
                                                            "The answer can't have more than 3 numbers!")))
                                                    .closed
                                                    .then((value) {
                                                  setState(() {
                                                    activeSnackbar = false;
                                                  });
                                                });
                                              }
                                            } else {
                                              if (index == 10) {
                                                userResponse =
                                                    userResponse + "0";
                                              } else {
                                                userResponse = userResponse +
                                                    (index + 1).toString();
                                              }
                                            }
                                          });
                                        }
                                      },
                                      onLongPress: () async {
                                        var vibration = await Vibration
                                            ?.hasCustomVibrationsSupport();

                                        if (vibration == true) {
                                          Vibration.vibrate(
                                              duration: 10,
                                              intensities: [1, 1]);
                                        } else {
                                          Vibration.vibrate();
                                        }

                                        if (index == 9) {
                                          setState(() {
                                            userResponse = "";
                                          });
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: index == 9
                                              ? Color.fromRGBO(234, 106, 106, 1)
                                              : index == 11
                                                  ? Color.fromRGBO(
                                                      131, 192, 129, 1)
                                                  : darkenColor(
                                                      level!.background,
                                                      1.0,
                                                      24),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        ),
                                        child: Center(
                                            child: (() {
                                          if (index == 9) {
                                            return Icon(Icons.backspace,
                                                color: Colors.white, size: 40);
                                          } else if (index == 11) {
                                            return Icon(Icons.check,
                                                color: Colors.white, size: 50);
                                          } else {
                                            return Text(
                                              index == 10
                                                  ? "0"
                                                  : (index + 1).toString(),
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Mansalva",
                                                  fontSize: 49),
                                            );
                                          }
                                        }())),
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
            if (tutorial)
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
                      top: numberPositions[1] - 75,
                      left: numberPositions[0] + 12,
                      child: Container(
                        margin: const EdgeInsets.only(top: 80),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(35),
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
            if (tutorial)
              Positioned(
                top: numberPositions[1] + 140,
                left: numberPositions[0] + 20,
                child: Container(
                  width: 280,
                  child: Text(
                    "Answer a maths question with\nthe keypad",
                    style: new TextStyle(
                        fontFamily: 'IndieFlower',
                        fontSize: 37,
                        color: Colors.white),
                  ),
                ),
              ),
            if (tutorial)
              Positioned(
                  top: numberPositions[1] + 250,
                  left: numberPositions[0] + 240,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tutorial = false;
                      });
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
            if (tutorial)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 350,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/bird-616803.png',
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.bottomCenter,
                  ),
                  transform: Matrix4.translationValues(100, -200.0, 0.0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
