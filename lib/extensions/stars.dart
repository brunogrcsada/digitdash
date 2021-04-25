//Packages
import 'package:flutter/material.dart';
import 'package:decorated_icon/decorated_icon.dart';

class Stars extends StatefulWidget {
  final int starNumber;
  Stars({Key? key, required this.starNumber}) : super(key: key);

  @override
  _StarsState createState() => _StarsState(starNumber: this.starNumber);
}

class _StarsState extends State<Stars> {
  int starNumber;

  _StarsState({required this.starNumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        if (index + 1 <= starNumber) {
          return DecoratedIcon(
            Icons.star_rounded,
            color: Color.fromRGBO(255, 212, 1, 1),
            size: 70.0,
            shadows: [
              BoxShadow(
                blurRadius: 10.0,
                color: Color.fromRGBO(0, 0, 0, 100),
              ),
            ],
          );
        } else {
          return DecoratedIcon(
            Icons.star_outline_rounded,
            color: Colors.white,
            size: 70.0,
            shadows: [
              BoxShadow(
                blurRadius: 5.0,
                color: Color.fromRGBO(0, 0, 0, 200),
              ),
            ],
          );
        }
      }),
    );
  }
}
