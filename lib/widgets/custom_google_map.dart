import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place_model.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
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
    initMarkers();
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

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          //for first camera open
          initialCameraPosition: initialCameraPosition,
          //to change map style
          onMapCreated: (controller) {
            googleMapController = controller;
            initMapStyle();
          },
          //for add markers
          markers: markers,
          //to change my location
          // onMapCreated: (ctr) {
          //   ctr = googleMapController;
          // },
          // cameraTargetBounds: CameraTargetBounds(
          //   LatLngBounds(
          //     northeast: const LatLng(31.06341706114919, 31.40887747116393),
          //     southwest: const LatLng(31.06341706114919, 31.40887747116393),
          //   ),
          // ), //تحديد نطاق للعميل لا يمكن تحريك الكاميرا اكثر من ذلك
        ),
        // Positioned(
        //   bottom: 16,
        //   left: 16,
        //   right: 200,
        //   child: ElevatedButton(
        //     onPressed: () {
        //       CameraPosition newLocation = const CameraPosition(
        //         target: LatLng(
        //           30.972415427131867,
        //           31.188388231953255,
        //         ),
        //         zoom: 12,
        //       );
        //       googleMapController.animateCamera(
        //         CameraUpdate.newCameraPosition(newLocation),
        //       );
        //     },
        //     child: const Text(
        //       "Change Location",
        //     ),
        //   ),
        // ),
      ],
    );
  }

  //to add markers
  void initMarkers() {
    // var myMarker = Marker(
    //   markerId: MarkerId(
    //     "1",
    //   ),
    //   position: LatLng(
    //     31.06341706114919,
    //     31.40887747116393,
    //   ),
    // );
    var myMarkers = places
        .map(
          (placeModel) => Marker(
            markerId: MarkerId(placeModel.id.toString()),
            position: placeModel.latLng,
            infoWindow: InfoWindow(
              title: placeModel.name,
            ),
          ),
        )
        .toSet();
    markers.addAll(myMarkers);
  }
}

//world view --> range zoom = 0 : 3
//country view --> range zoom = 4 : 6
//city view --> range zoom = 10 : 12
//street view --> range zoom = 13 : 17
//building view --> range zoom = 18 : 20
