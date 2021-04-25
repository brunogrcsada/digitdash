//Packages
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

//Components
import '../levels.dart';

class LevelPath extends CustomPainter {
  final Level level;
  final List<double> nextPosition;
  List<double> levelPosition;
  bool valueSet;
  String unlockStatus;
  List<Offset> startOffset;

  LevelPath(
      {required this.level,
      required this.nextPosition,
      required this.levelPosition,
      required this.valueSet,
      required this.unlockStatus,
      required this.startOffset});

  @override
  void paint(Canvas canvas, Size size) {
    if (!valueSet) {
      valueSet = true;
      startOffset[0] = Offset(levelPosition[0] + 50, levelPosition[1] - 80);
      startOffset[1] = Offset(nextPosition[0] + 50, nextPosition[1] - 50);
    }

    var paint = Paint();

    paint.color = unlockStatus == "true"
        ? level.background
        : Color.fromRGBO(206, 206, 206, 1);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = unlockStatus == "true" ? 10 : 8;

    var listDouble = level.curve.map((i) => i.toDouble()).toList();

    var controlPoint1 = Offset(listDouble[0], listDouble[1]);
    var controlPoint2 = Offset(listDouble[2], listDouble[3]);

    //Third line test:
    //var controlPoint1 = Offset(160, 790);
    //var controlPoint2 = Offset(250, 550);

    //Second line test:

    //var controlPoint1 = Offset(230,500);
    //var controlPoint2 = Offset(110,340);

    //var controlPoint1 = Offset(300,550);
    //var controlPoint2 = Offset(90,300);

    var path = Path();

    path.moveTo(startOffset[0].dx, startOffset[0].dy);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, startOffset[1].dx, startOffset[1].dy);

    canvas.drawPath(
      (() {
        if (unlockStatus == "true") {
          return dashPath(
            path,
            dashArray: unlockStatus == "true"
                ? CircularIntervalList<double>(<double>[25.0, 25.0])
                : CircularIntervalList<double>(<double>[1.0, 1.0]),
          );
        } else {
          return path;
        }
      }()),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
