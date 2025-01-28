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
    const click = Duration(milliseconds: 500);
    var rng = Random();
    Timer.periodic(click,
            (Timer t) => eventObservable.add(rng.nextInt(59) + rng.nextDouble()));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the size dynamically based on available width
        double size = constraints.maxWidth * 0.8;
        double padding = size * 0.05;

        final ThemeData theme = Theme.of(context);

        ThemeData somTheme = theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.blue,
            secondary: Colors.blue,
            background: Colors.blue.shade100,
          ),
        );

        var speedOMeter = Transform.scale(
          scale: constraints.maxWidth / 400,
          child: SpeedOMeter(
            start: start,
            end: end,
            highlightStart: (_lowerValue / end),
            highlightEnd: (_upperValue / end),
            themeData: somTheme,
            eventObservable: this.eventObservable,
            animationDuration: _animationDuration,
          ),
        );


        return Center(
          child: Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(padding),
            child: speedOMeter,
          ),
        );
      },
    );
  }
}
