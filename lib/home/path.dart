
//Packages
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

//Components
import '../extensions/position.dart';
import '../levels.dart';

class LevelPath extends CustomPainter {
  final Level level;
  final GlobalKey nextKey;
  bool valueSet;
  List<Offset> startOffset;

  LevelPath({
    required this.level,
    required this.nextKey,
    required this.valueSet,
    required this.startOffset
  });

  @override
  void paint(Canvas canvas, Size size) {

    if(!valueSet){

        valueSet = true;

        startOffset[0] = Offset(level.globalKey.widgetCoordinates[0] + 50,
        level.globalKey.widgetCoordinates[1] - 80);

        startOffset[1] = Offset(
            nextKey.widgetCoordinates[0] + 50, nextKey.widgetCoordinates[1] - 50);

    }

    var paint = Paint();

        paint.color = level.background;
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 10;

        var listDouble = level.curve.map((i) => i.toDouble()).toList();

        //todo: find another way to grab doubles from a list...
        var controlPoint1 = Offset(listDouble[0], listDouble[1]);
        var controlPoint2 = Offset(listDouble[2], listDouble[3]);

        //Third line test:
        //var controlPoint1 = Offset(190,900);
        //var controlPoint2 = Offset(290,400);

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