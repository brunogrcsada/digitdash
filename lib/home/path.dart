
//Packages
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

//Components
import '../extensions/position.dart';
import '../levels.dart';

class LevelPath extends CustomPainter {
  final Level level;
  final GlobalKey nextKey;

  LevelPath({
    required this.level,
    required this.nextKey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = level.background;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 10;
    
    var startPoint = Offset(level.globalKey.widgetCoordinates[0] + 50,
        level.globalKey.widgetCoordinates[1] - 80);

    var listDouble = level.curve.map((i) => i.toDouble()).toList();

    //todo: find another way to grab doubles from a list...
    //var controlPoint1 = Offset(listDouble[0], listDouble[1]);
    //var controlPoint2 = Offset(listDouble[2], listDouble[3]);

    var controlPoint1 = Offset(450,500);
    var controlPoint2 = Offset(20,400);
    
    print(controlPoint1);

    var endPoint = Offset(
        nextKey.widgetCoordinates[0] + 50, nextKey.widgetCoordinates[1] - 50);

    var path = Path();

    path.moveTo(startPoint.dx, startPoint.dy);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(
      dashPath(
        path,
        dashArray: CircularIntervalList<double>(<double>[25.0, 25.0]),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}