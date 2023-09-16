import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class RichterConverter {
  final List<AccelerometerEvent> accelerometerEvents;

  RichterConverter(this.accelerometerEvents);

  double calculateRichter() {
    double maxAmplitude = 0.0;

    for (var event in accelerometerEvents) {
      // Calculate the amplitude as the square root of the sum of squared accelerations in X, Y, and Z axes.
      double amplitude =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      // Find the maximum amplitude in the dataset.
      if (amplitude > maxAmplitude) {
        maxAmplitude = amplitude;
      }
    }

    // Estimate Richter scale value based on the maximum amplitude.
    double richterValue = log(maxAmplitude) / log(10.0) + 1.44;

    return richterValue;
  }
}
