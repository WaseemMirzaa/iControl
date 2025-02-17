import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';

class SpeedMeter extends StatefulWidget {
  final double maxSpeed;
  final double speed;
  final String unitOfMeasurement;
  final List<double> alertSpeedArray;

  const SpeedMeter({
    super.key,
    required this.maxSpeed,
    required this.speed,
    required this.unitOfMeasurement,
    required this.alertSpeedArray,
  });

  @override
  State<SpeedMeter> createState() => _SpeedMeterState();
}

class _SpeedMeterState extends State<SpeedMeter> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final minDimension = size.width < size.height ? size.width : size.height;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final gaugeSize = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;

          final baseTextSize = gaugeSize * 0.06;

          return SizedBox(
            width: gaugeSize,
            height: gaugeSize,
            child: KdGaugeView(
              innerCirclePadding: 15,
              minSpeed: 0,
              maxSpeed: widget.maxSpeed,
              speed: widget.speed,
              animate: true,
              duration: const Duration(seconds: 1),
              alertColorArray: const [Colors.blue, Colors.orange, Colors.red],
              alertSpeedArray: widget.alertSpeedArray,
              unitOfMeasurement: widget.unitOfMeasurement,
              gaugeWidth: minDimension * 0.015,
              fractionDigits: 1,
              speedTextStyle: TextStyle(
                color: Colors.black,
                fontSize: baseTextSize * 2,
                fontWeight: FontWeight.bold,
              ),
              unitOfMeasurementTextStyle: TextStyle(
                color: Colors.black,
                fontSize: baseTextSize * 1.5,
                fontWeight: FontWeight.w700,
              ),
              minMaxTextStyle: TextStyle(
                color: Colors.black,
                fontSize: baseTextSize * 0.8,
              ),
            ),
          );
        },
      ),
    );
  }
}