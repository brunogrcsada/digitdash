import 'package:flutter/material.dart';

class LevelCircle extends StatelessWidget{
    final int? level;
    final Color? background;
    final Color? foreground;

    LevelCircle({Key? key, 
            @required this.level, 
            @required this.background,
            @required this.foreground,
    }) : super(key: key);

    @override
    Widget build(BuildContext context){
      return Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
          color: background,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            level.toString(),
            style: new TextStyle(
              fontSize: 55,
              color: foreground,
              fontFamily: 'Mansalva'
            ),
          ),
        ),
      );
    }
}