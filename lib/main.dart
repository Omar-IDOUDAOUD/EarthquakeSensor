import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const EarthquakeSensor());
}

class EarthquakeSensor extends StatelessWidget {
  const EarthquakeSensor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
