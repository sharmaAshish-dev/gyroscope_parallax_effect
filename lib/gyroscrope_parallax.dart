import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeParallax extends ConsumerStatefulWidget {
  const GyroscopeParallax({Key? key}) : super(key: key);

  @override
  ConsumerState<GyroscopeParallax> createState() => _GyroscopeParallaxState();
}

class _GyroscopeParallaxState extends ConsumerState<GyroscopeParallax> {
  String imgUrl = 'assets/images/scene.jpg';

  final initX = StateProvider<double>((ref) => 0.0);
  final initY = StateProvider<double>((ref) => 0.0);

  @override
  void initState() {
    super.initState();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (event.y.abs() > 0.0) {
        ref.read(initY.notifier).state = event.y * 10;
      }
      if (event.x.abs() > 0.0) {
        ref.read(initX.notifier).state = event.x * 10;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 20 + (ref.watch(initY)),
            right: 20 - (ref.watch(initY)),
            top: 20 + (ref.watch(initX)),
            bottom: 20 - (ref.watch(initX)),
            child: Center(
              child: Container(
                width: 250,
                height: 350,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20 - (ref.watch(initY)),
            right: 20 + (ref.watch(initY)),
            top: 20 - (ref.watch(initX)),
            bottom: 20 + (ref.watch(initX)),
            child: Center(
              child: AnimatedContainer(
                width: 250,
                height: 350,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: .1),
                  image: DecorationImage(image: AssetImage(imgUrl), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ), duration: const Duration(milliseconds: 100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
