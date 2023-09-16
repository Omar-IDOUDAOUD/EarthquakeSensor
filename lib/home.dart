import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
      ),
      backgroundColor: Colors.white,
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _getChartFram(SensorsPlatform.instance.gyroscopeEvents, 0),
          _getChartFram(SensorsPlatform.instance.userAccelerometerEvents, 1),
          _getChartFram(SensorsPlatform.instance.accelerometerEvents, 2),
          _getChartFram(SensorsPlatform.instance.magnetometerEvents, 3)
        ],
      ),
    );
  }

  final List<List<String>> _listOfLog = List.generate(4, (index) => []);

  Widget _getChartFram(Stream stream, int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ColoredBox(
        color: Colors.grey.shade200,
        child: SizedBox(
          height: 200,
          child: Builder(builder: (context) {
            double minRecValue = 10;
            return Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'min record value'),
                  onChanged: (String v) {
                    try {
                      minRecValue = v as double;
                    } catch (e) {
                      minRecValue = 10;
                    }
                  },
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: stream..listen((event) {}),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          (snapshot.data!.x as double).abs() >= 1 &&
                          (snapshot.data!.y as double).abs() >= 1 &&
                          (snapshot.data!.z as double).abs() >= 1)
                        _listOfLog[i].add(snapshot.data.toString());
                      return ListView.separated(
                        reverse: true,
                        padding: EdgeInsets.all(10),
                        itemCount: _listOfLog.elementAt(i).length,
                        separatorBuilder: (_, i) => SizedBox(
                          height: 5,
                        ),
                        itemBuilder: (_, index) {
                          return Text(_listOfLog.elementAt(i).elementAt(index));
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
