import 'package:flutter/material.dart';
import 'package:google_maps_udemy/widgets/custom_google_map.dart';
import 'package:google_maps_udemy/widgets/live_tracking.dart';

void main() {
  runApp(const TestGoogleMapsWithFlutter());
}

class TestGoogleMapsWithFlutter extends StatelessWidget {
  const TestGoogleMapsWithFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Map Test & Live Tracking & Route Tracking',
      debugShowCheckedModeBanner: false,
      home: LiveTracking(),
    );
  }
}

//world view --> range zoom = 0 : 3
//country view --> range zoom = 4 : 6
//city view --> range zoom = 10 : 12
//street view --> range zoom = 13 : 17
//building view --> range zoom = 18 : 20

// ---------------------------------------

//enable location service
// about permissions
//request permission
//get location
//display
