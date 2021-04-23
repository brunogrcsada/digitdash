import 'package:flutter/material.dart';

extension containerPosition on GlobalKey {
  List get widgetCoordinates {

    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();

    if (translation != null && renderObject?.paintBounds != null) {
      return [translation.x, translation.y];
    } else {
      return [];
    }

  }
}