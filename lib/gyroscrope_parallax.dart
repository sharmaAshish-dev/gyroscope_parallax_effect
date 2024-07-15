import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class GyroscopeParallax extends StatefulWidget {
  const GyroscopeParallax({Key? key}) : super(key: key);

  @override
  _GyroscopeParallaxState createState() => _GyroscopeParallaxState();
}

class _GyroscopeParallaxState extends State<GyroscopeParallax> {
  String imgUrl = 'assets/images/scene.jpg';

  final ValueNotifier<double> offsetX = ValueNotifier<double>(0.0);
  final ValueNotifier<double> offsetY = ValueNotifier<double>(0.0);

  double lastX = 0.0;
  double lastY = 0.0;
  final double alpha = 0.2; // Smoothing factor

  Timer? debounceTimerX;
  Timer? debounceTimerY;

  @override
  void initState() {
    super.initState();
    gyroscopeEventStream().listen((GyroscopeEvent event) {
      double filteredX = lastX + alpha * (event.y - lastX); // event.y for x axis tilt
      double filteredY = lastY + alpha * (event.x - lastY); // event.x for y axis tilt
      lastX = filteredX;
      lastY = filteredY;

      if (filteredX.abs() > 0.0) {
        debounceTimerX?.cancel();
        offsetX.value = filteredX * 60; // Adjust multiplier as needed
        debounceTimerX = Timer(const Duration(milliseconds: 100), () {
          offsetX.value = offsetX.value;
        });
      }

      if (filteredY.abs() > 0.0) {
        debounceTimerY?.cancel();
        offsetY.value = filteredY * 60; // Adjust multiplier as needed
        debounceTimerY = Timer(const Duration(milliseconds: 100), () {
          offsetY.value = offsetY.value;
        });
      }
    });
  }

  @override
  void dispose() {
    debounceTimerX?.cancel();
    debounceTimerY?.cancel();
    offsetX.dispose();
    offsetY.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> squares = List.generate(20, (index) { // Increase the number of squares
      double size = 100.0 + index * 50.0; // Adjust size based on index
      double opacity = 1.0 - (index + 1) / 20.0; // Calculate opacity based on index

      return ValueListenableBuilder<double>(
        valueListenable: offsetX,
        builder: (context, xValue, child) {
          return ValueListenableBuilder<double>(
            valueListenable: offsetY,
            builder: (context, yValue, child) {
              double left = MediaQuery.of(context).size.width / 2 - size / 2 + xValue * (index + 1) * 0.3;
              double top = MediaQuery.of(context).size.height / 2 - size / 2 + yValue * (index + 1) * 0.3;

              // Ensure left and top values are within valid ranges
              left = left.isFinite ? left : 0;
              top = top.isFinite ? top : 0;

              return Positioned(
                left: left,
                top: top,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white.withOpacity(opacity), width: 0.5),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: index == 0 ? Center(
                    child: Image.asset(
                      imgUrl,
                      fit: BoxFit.cover,
                    ),
                  ) : null,
                ),
              );
            },
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ...squares,
        ],
      ),
    );
  }
}
