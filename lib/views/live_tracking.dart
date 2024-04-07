import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_udemy/utils/location_service.dart';
import 'package:location/location.dart';

class LiveTracking extends StatefulWidget {
  const LiveTracking({super.key});

  @override
  State<LiveTracking> createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  late CameraPosition initialCameraPosition;

  GoogleMapController? googleMapController;

  bool isFirstCall = true;

  late LocationService locationService;

  Set<Marker> markers = {};

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(
        31.06341706114919,
        31.40887747116393,
      ),
      zoom: 16,
    );
    locationService = LocationService();
    updateMyLocation();
    super.initState();
  }

  //to change map style
  void initMapStyle() async {
    var nightMapStyle = await DefaultAssetBundle.of(context).loadString(
      "assets/map_styles/night_map_style.json",
    );
    googleMapController!.setMapStyle(nightMapStyle);
  }

  @override
  void dispose() {
    googleMapController!.dispose();
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
          //add marker based on new location
          markers: markers,
        ),
      ],
    );
  }

  void updateMyLocation() async {
    await locationService.checkAndRequestLocationService();
    var hasPermission =
        await locationService.checkAndRequestLocationPermission();
    // if (hasPermission) {
    //   locationService.getRealTimeLocation((locationData) {
    //     setMyLocationMarker(locationData);
    //     updateCamera(locationData);
    //   });
    // } else {}
  }

  void setMyLocationMarker(LocationData locationData) {
    var myLocationMarker = Marker(
      markerId: const MarkerId(
        "Marker",
      ),
      position: LatLng(
        locationData.latitude!,
        locationData.longitude!,
      ),
    );
    markers.add(myLocationMarker);
    setState(() {});
  }

  void updateCamera(LocationData locationData) {
    if (isFirstCall) {
      newPosition(locationData);
      isFirstCall = false;
    } else {
      newLatLng(locationData);
    }
  }

  void newLatLng(LocationData locationData) {
    googleMapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          locationData.latitude!,
          locationData.longitude!,
        ),
      ),
    );
  }

  void newPosition(LocationData locationData) {
    var cameraPosition = CameraPosition(
      target: LatLng(
        locationData.latitude!,
        locationData.longitude!,
      ),
      zoom: 15,
    );
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );
  }
}
