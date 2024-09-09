import 'package:flutter/material.dart';

class DrowingPoint {
  int id;
  List<Offset> offset;
  Color color;
  double width;

  DrowingPoint({
    this.id = 1,
    this.offset = const [],
    this.color = Colors.black,
    this.width = 2,
  });

  DrowingPoint copyWith({List<Offset>? offset}) {
    return DrowingPoint(
      id: id,
      color: color,
      width: width,
      offset: offset ?? this.offset,
    );
  }
}
