//Packages
import 'package:flutter/material.dart';

darkenColor(Color color, double o, int darker) {
  var r = color.red - darker;
  var g = color.green - darker;
  var b = color.blue - darker;

  return Color.fromRGBO(r, g, b, o);
}
