import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_udemy/utils/location_service.dart';
import 'package:google_maps_udemy/utils/map_services.dart';
import 'package:google_maps_udemy/widgets/input.dart';
import 'package:google_maps_udemy/widgets/result_listview.dart';
import 'package:uuid/uuid.dart';
import '../models/place_autocomplete_model/place_autocomplete_model.dart';

class RouteTrackingView extends StatefulWidget {
  const RouteTrackingView({super.key});

  @override
  State<RouteTrackingView> createState() => _RouteTrackingViewState();
}

class _RouteTrackingViewState extends State<RouteTrackingView> {
  late CameraPosition initialCameraPosition;

  late MapServices mapServices;

  late GoogleMapController googleMapController;

  late TextEditingController searchCtrl;

  late Uuid uuid;

  late LatLng currentLocation;

  late LatLng destination;

  String? sessionToken;

  List<PlaceModel> places = [];

  Timer? debounce;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0));

    uuid = const Uuid();

    mapServices = MapServices();

    searchCtrl = TextEditingController();

    fetchPredictions();

    super.initState();
  }

  void fetchPredictions() {
    searchCtrl.addListener(
      () {
        if (debounce?.isActive ?? false) {
          debounce?.cancel();
        }
        debounce = Timer(const Duration(milliseconds: 500), () async {
          sessionToken ??= uuid.v4();
          print("sessionToken = $sessionToken");
          await mapServices.getPredictions(
            input: searchCtrl.text,
            session: sessionToken!,
            places: places,
          );
          setState(() {});
        });
      },
    );
  }

  Set<Marker> markers = {};

  Set<Polyline> polylines = {};

  @override
  void dispose() {
    searchCtrl.dispose();
    debounce?.cancel();
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
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              polylines: polylines,
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
                  ResultListView(
                    places: places,
                    mapServices: mapServices,
                    onPlaceSelect: (placeDetailsModel) async {
                      searchCtrl.clear();
                      places.clear();
                      sessionToken = null;
                      setState(() {});
                      destination = LatLng(
                        placeDetailsModel.geometry!.location!.lat!,
                        placeDetailsModel.geometry!.location!.lng!,
                      );
                      var points = await mapServices.getRoutesData(
                        currentLocation: currentLocation,
                        secondLocation: destination,
                      );
                      mapServices.displayPoints(
                        points,
                        polylines: polylines,
                        googleMapController: googleMapController,
                      );
                      setState(() {});
                    },
                  ),
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
      currentLocation = await mapServices.updateCurrentLocation(
        googleMapController: googleMapController,
        markers: markers,
      );
      setState(() {});
    } on LocationServiceException catch (e) {
    } on LocationPermissionException catch (e) {
    } catch (e) {}
  }

// Future<List<LatLng>> getRoutesData() async {
//   LocationInfoModel origin = LocationInfoModel(
//     location: LocationModel(
//       latLng: LatLngModel(
//         latitude: currentPosition.latitude,
//         longitude: currentPosition.longitude,
//       ),
//     ),
//   );
//
//   LocationInfoModel destination = LocationInfoModel(
//     location: LocationModel(
//       latLng: LatLngModel(
//         latitude: destination.latitude,
//         longitude: destination.longitude,
//       ),
//     ),
//   );
//
//   RoutesModel routes = await routesService.fetchRoutes(
//       origin: origin, destination: destination);
//
//   PolylinePoints polylinePoints = PolylinePoints();
//
//   List<LatLng> points = getDecodedRoute(polylinePoints, routes);
//
//   return points;
// }
//
// List<LatLng> getDecodedRoute(
//     PolylinePoints polylinePoints, RoutesModel routes) {
//   List<PointLatLng> results = polylinePoints.decodePolyline(
//     routes.routes!.first.polyline!.encodedPolyline!,
//   );
//
//   List<LatLng> points = results
//       .map(
//         (e) => LatLng(
//           e.latitude,
//           e.longitude,
//         ),
//       )
//       .toList();
//   return points;
// }
//
// void displayPoints(List<LatLng> points) {
//   Polyline route = Polyline(
//     color: Colors.blue,
//     width: 5,
//     polylineId: const PolylineId("Route"),
//     points: points,
//   );
//
//   LatLngBounds bounds = getLatLngBounds(points);
//   googleMapController.animateCamera(
//     CameraUpdate.newLatLngBounds(
//       bounds,
//       35,
//     ),
//   );
//
//   polylines.add(route);
//   setState(() {});
// }
//
// LatLngBounds getLatLngBounds(List<LatLng> points) {
//   var southWestLatitude = points.first.latitude;
//   var southWestLongitude = points.first.longitude;
//   var northEastLatitude = points.first.latitude;
//   var northEastLongitude = points.first.longitude;
//
//   for (var point in points) {
//     southWestLatitude = min(southWestLatitude, point.latitude);
//     southWestLongitude = min(southWestLongitude, point.longitude);
//     northEastLatitude = max(northEastLatitude, point.latitude);
//     northEastLongitude = max(northEastLongitude, point.longitude);
//   }
//
//   return LatLngBounds(
//     southwest: LatLng(
//       southWestLatitude,
//       southWestLongitude,
//     ),
//     northeast: LatLng(
//       northEastLatitude,
//       northEastLongitude,
//     ),
//   );
// }
}
