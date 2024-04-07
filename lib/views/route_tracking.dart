import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_udemy/utils/google_maps_places_service.dart';
import 'package:google_maps_udemy/utils/location_service.dart';
import 'package:google_maps_udemy/widgets/input.dart';
import 'package:google_maps_udemy/widgets/result_listview.dart';

import '../models/place_autocomplete_model/place_autocomplete_model.dart';

class RouteTrackingView extends StatefulWidget {
  const RouteTrackingView({super.key});

  @override
  State<RouteTrackingView> createState() => _RouteTrackingViewState();
}

class _RouteTrackingViewState extends State<RouteTrackingView> {
  late CameraPosition initialCameraPosition;

  late LocationService locationService;

  late GoogleMapController googleMapController;

  late TextEditingController searchCtrl;

  late GoogleMapsPlacesService googleMapsPlacesService;

  List<PlaceModel> places = [];

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0));

    locationService = LocationService();

    googleMapsPlacesService = GoogleMapsPlacesService();

    searchCtrl = TextEditingController();

    fetchPredictions();

    super.initState();
  }

  void fetchPredictions() {
    searchCtrl.addListener(
      () async {
        if (searchCtrl.text.isNotEmpty) {
          var result = await googleMapsPlacesService.getPredictions(
            input: searchCtrl.text,
          );
          places.clear();
          places.addAll(result);
          setState(() {});
        } else {
          places.clear();
          setState(() {});
        }
      },
    );
  }

  Set<Marker> markers = {};

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              //for first camera open
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              onMapCreated: (controller) {
                googleMapController = controller;
                updateCurrentLocation();
              },
            ),
            Positioned(
              top: 14,
              right: 14,
              left: 14,
              child: Column(
                children: [
                  AppInput(
                    textEditingController: searchCtrl,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ResultListView(places: places),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateCurrentLocation() async {
    try {
      var locationData = await locationService.getLocation();

      LatLng currentPosition = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      Marker currentLocationMarker = Marker(
        markerId: MarkerId(
          "MyLocation",
        ),
        position: currentPosition,
      );
      CameraPosition cameraPosition = CameraPosition(
        target: currentPosition,
        zoom: 16,
      );
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          cameraPosition,
        ),
      );
      markers.add(currentLocationMarker);
      setState(() {});
    } on LocationServiceException catch (e) {
    } on LocationPermissionException catch (e) {
    } catch (e) {}
  }
}
