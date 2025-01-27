import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:speedometer/speedometer.dart';
import 'package:rxdart/rxdart.dart';

class SpeedometerWidget extends StatefulWidget {
  @override
  _SpeedometerWidgetState createState() => _SpeedometerWidgetState();
}

class _SpeedometerWidgetState extends State<SpeedometerWidget> {
  double _lowerValue = 20.0;
  double _upperValue = 40.0;
  int start = 0;
  int end = 60;

  Duration _animationDuration = Duration(milliseconds: 100);

  PublishSubject<double> eventObservable = PublishSubject();

  @override
  void initState() {
    super.initState();
    const click = const Duration(milliseconds: 500);
    var rng = Random();
    Timer.periodic(click,
            (Timer t) => eventObservable.add(rng.nextInt(59) + rng.nextDouble()));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Updated themeData to make the speedometer blue
    ThemeData somTheme = theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: Colors.blue, // Blue primary color
        secondary: Colors.blue, // Blue secondary color
        background: Colors.blue.shade100, // Light blue background
      ),
    );

    var speedOMeter = SpeedOMeter(
      start: start,
      end: end,
      highlightStart: (_lowerValue / end),
      highlightEnd: (_upperValue / end),
      themeData: somTheme,
      eventObservable: this.eventObservable,
      animationDuration: _animationDuration,
    );

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(40.0),
          child: speedOMeter,
        ),
      ],
    );
  }
}
