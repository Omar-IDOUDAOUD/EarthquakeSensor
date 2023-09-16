// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class LogItem {
  final double x;
  final double y;
  final DateTime dateTime;
  final Duration duration;

  LogItem(
      {required this.x,
      required this.y,
      required this.dateTime,
      required this.duration});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<LogItem> _eventsLog = List.generate(50, (index) {
    return LogItem(
        x: 10,
        y: index.toDouble(),
        dateTime: DateTime.now(),
        duration: Duration(milliseconds: 500));
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 30,
        shadowColor: Colors.black.withOpacity(.3),
        title: Text(
          'Earthquake sensor & monitor',
          style: TextStyle(
            color: Colors.blueGrey.shade900,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.history_rounded,
              color: Colors.blueGrey.shade900,
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ListView.separated(
                      reverse: true,
                      padding: const EdgeInsets.all(15),
                      itemCount: _eventsLog.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 5,
                      ),
                      itemBuilder: (_, i) {
                        return Text(_eventsLog.elementAt(i).y.toString());
                      },
                    );
                  });
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _Body(
        onAddLog: (log) {
          _eventsLog.add(log);
        },
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({super.key, required this.onAddLog});
  final Function(LogItem) onAddLog;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  double _minAlertValue = 1;
  double _maxRecordValue = 10;

  Size? _size;
  final double _padding = 15;
  late final Size _c1s;
  late final Size _c2s;
  late final Size _c3s;
  Offset _indexCircleOffset = Offset.zero;
  bool _useDangerColor = false;
  final _accelerometerStream = SensorsPlatform.instance.accelerometerEvents;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Timer.periodic(Duration(milliseconds: 900), (timer) {
    //   //50 => _c1s-_cls3
    //   //1 => 1*(_c1s-_cls3)/50
    // });

    _accelerometerStream.listen((event) {
      final sfactor = Size.square(_c1s.width - _c3s.width);
      final dx = event.x * sfactor.width / _maxRecordValue;
      final dy = event.y * sfactor.width / _maxRecordValue;

      setState(() {
        if (dx >= _minAlertValue || dy >= _minAlertValue) {
          // widget.onAddLog("x = $dx, y = $dy");
          // _startRecordingLog();
          _useDangerColor = true;
        }
        _indexCircleOffset = Offset(dx, dy);
      });
    });
  }

  _initializeCirclesSizes() {
    if (_size != null) return;
    _size = MediaQuery.sizeOf(context);
    _c1s = Size.square(_size!.width - _padding);
    _c2s = _c1s / 1.5;
    _c3s = _c1s / 3;
  }
  // bool _itsRecordingLogCurrently = false;
  // void _startRecordingLog(){
  //   if (_itsRecordingLogCurrently) return;
  //   _itsRecordingLogCurrently = true;
  //   final List<double> xColl = [];
  //   final List<double> yColl = [];
  //   _accelerometerStream.listen((event) {
  //     xColl.add(event.x);
  //     yColl.add(event.y);
  //   });

  //   // Duration(milliseconds: 500)
  // }

  @override
  Widget build(BuildContext context) {
    _initializeCirclesSizes();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              Text(
                'min alert value: ${_minAlertValue.toStringAsFixed(1)}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (_minAlertValue <= 0.1) return;
                  setState(() {
                    if (_minAlertValue <= 1)
                      _minAlertValue -= 0.1;
                    else
                      _minAlertValue -= 0.5;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    if (_minAlertValue < 1)
                      _minAlertValue += 0.1;
                    else
                      _minAlertValue += 0.5;
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              Text(
                'max record value: ${_maxRecordValue}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (_maxRecordValue == 0) return;
                  setState(() {
                    _maxRecordValue -= 1;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _maxRecordValue += 1;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: _c1s.height,
                width: _c1s.width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
              ),
              Container(
                height: _c2s.height,
                width: _c2s.width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
              ),
              AnimatedContainer(
                onEnd: () {
                  setState(() {
                    _indexCircleOffset = Offset.zero;
                    _useDangerColor = false;
                  });
                },
                duration: Duration(milliseconds: 200),
                transform: Matrix4.identity()
                  ..setTranslationRaw(
                    _indexCircleOffset.dx,
                    _indexCircleOffset.dy,
                    0,
                  ),
                height: _c3s.height,
                width: _c3s.width,
                decoration: BoxDecoration(
                  color:
                      _useDangerColor ? Colors.redAccent : Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        // Expanded(
        //
        // )
      ],
    );
  }
}
