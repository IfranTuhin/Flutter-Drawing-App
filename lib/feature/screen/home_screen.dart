import 'package:drawing_app/feature/model/drowing_point.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Colors
  var avaialableColor = [
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.pink,
  ];

  var historyDrowingPoint = <DrowingPoint>[];
  var drawingPoint = <DrowingPoint>[];

  var selectedColor = Colors.black;
  var selectedWidth = 2.0;

  DrowingPoint? currentDrawingPint;

  @override
  Widget build(BuildContext context) {
    // Screen Size
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Canvas
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                currentDrawingPint = DrowingPoint(
                  id: DateTime.now().microsecondsSinceEpoch,
                  offset: [
                    details.localPosition,
                  ],
                  color: selectedColor,
                  width: selectedWidth,
                );
                if (currentDrawingPint == null) return;
                drawingPoint.add(currentDrawingPint!);
                historyDrowingPoint = List.of(drawingPoint);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                if (currentDrawingPint == null) return;

                currentDrawingPint = currentDrawingPint?.copyWith(
                  offset: currentDrawingPint!.offset
                    ..add(details.localPosition),
                );
                drawingPoint.last = currentDrawingPint!;
                historyDrowingPoint = List.of(drawingPoint);
              });
            },
            onPanEnd: (details) {
              setState(() {
                currentDrawingPint = null;
              });
            },
            child: CustomPaint(
              painter: DrowingPainter(
                drawingPoits: drawingPoint,
              ),
              child: SizedBox(
                height: size.height,
                width: size.width,
              ),
            ),
          ),

          // Color circle
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: avaialableColor.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = avaialableColor[index];
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: avaialableColor[index],
                        shape: BoxShape.circle,
                      ),
                      foregroundDecoration: BoxDecoration(
                        border: selectedColor == avaialableColor[index]
                            ? Border.all(color: Colors.deepPurple, width: 3)
                            : null,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Pensil size Slider
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 0,
            bottom: 150,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                min: 1,
                max: 20,
                value: selectedWidth,
                onChanged: (value) {
                  setState(() {
                    selectedWidth = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),

      // Undo Redo Floation action buttons
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'Undo',
            onPressed: () {
              if (drawingPoint.isNotEmpty && historyDrowingPoint.isNotEmpty) {
                setState(() {
                  drawingPoint.removeLast();
                });
              }
            },
            child: const Icon(Icons.undo),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'Redo',
            onPressed: () {
              setState(() {
                if (drawingPoint.length < historyDrowingPoint.length) {
                  final index = drawingPoint.length;
                  drawingPoint.add(historyDrowingPoint[index]);
                }
              });
            },
            child: const Icon(Icons.redo),
          ),
        ],
      ),
    );
  }
}

class DrowingPainter extends CustomPainter {
  final List<DrowingPoint> drawingPoits;

  DrowingPainter({required this.drawingPoits});

  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoits) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;

      for (var i = 0; i < drawingPoint.offset.length; i++) {
        var notLastOffset = i != drawingPoint.offset.length - 1;

        if (notLastOffset) {
          final current = drawingPoint.offset[i];
          final next = drawingPoint.offset[i + 1];
          canvas.drawLine(current, next, paint);
        } else {
          // We don't draw
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
