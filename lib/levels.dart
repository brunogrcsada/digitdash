import 'package:flutter/material.dart';

class Level {
  Color background;
  Color foreground;
  GlobalKey globalKey;
  List curve;

  Level(this.background, this.foreground, this.globalKey, this.curve);
}

List<Level> levels = [
  Level(Color.fromRGBO(129, 208, 213, 1), Color.fromRGBO(75, 129, 133, 1),
      GlobalKey(), [300.0, 30.0, 420.0, 130.0]),
  Level(Color.fromRGBO(213, 129, 161, 1), Color.fromRGBO(148, 89, 111, 1),
      GlobalKey(), [230.0, 500.0, 110.0, 340.0]),
  Level(Color.fromRGBO(129, 213, 173, 1), Color.fromRGBO(97, 139, 119, 1),
      GlobalKey(), [190.0, 900.0, 290.0, 400.0]),
  Level(Color.fromRGBO(129, 213, 173, 1), Color.fromRGBO(97, 139, 119, 1),
      GlobalKey(), [200.0, 200.0, 200.0, 200.0]),
];
