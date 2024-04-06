import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LiveTracking extends StatefulWidget {
  const LiveTracking({super.key});

  @override
  State<LiveTracking> createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  late CameraPosition initialCameraPosition;

  late GoogleMapController googleMapController;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(
        31.06341706114919,
        31.40887747116393,
      ),
      zoom: 16,
    );
    super.initState();
  }

  //to change map style
  void initMapStyle() async {
    var nightMapStyle = await DefaultAssetBundle.of(context).loadString(
      "assets/map_styles/night_map_style.json",
    );
    googleMapController.setMapStyle(nightMapStyle);
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          //for first camera open
          initialCameraPosition: initialCameraPosition,
          //to change map style
          onMapCreated: (controller) {
            googleMapController = controller;
            initMapStyle();
          },
        ),
      ],
    );
  }
}
