import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_udemy/utils/google_maps_places_service.dart';
import 'package:google_maps_udemy/utils/location_service.dart';
import 'package:google_maps_udemy/utils/routes_service.dart';
import '../models/location_info/lat_lng.dart';
import '../models/location_info/location.dart';
import '../models/location_info/location_info.dart';
import '../models/place_autocomplete_model/place_autocomplete_model.dart';
import '../models/place_details_model/place_details_model.dart';
import '../models/routes_model/routes_model.dart';

class MapServices {
  PlacesService placesService = PlacesService();
  LocationService locationService = LocationService();
  RoutesService routesService = RoutesService();

  Future<void> getPredictions({
    required String input,
    required String session,
    required List<PlaceModel> places,
  }) async {
    if (input.isNotEmpty) {
      var result = await placesService.getPredictions(
        input: input,
        session: session,
      );
      places.clear();
      places.addAll(result);
    } else {
      places.clear();
    }
  }

  Future<List<LatLng>> getRoutesData(
      {required LatLng currentLocation, required LatLng secondLocation}) async {
    LocationInfoModel origin = LocationInfoModel(
      location: LocationModel(
        latLng: LatLngModel(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
        ),
      ),
    );

    LocationInfoModel destination = LocationInfoModel(
      location: LocationModel(
        latLng: LatLngModel(
          latitude: secondLocation.latitude,
          longitude: secondLocation.longitude,
        ),
      ),
    );

    RoutesModel routes = await routesService.fetchRoutes(
        origin: origin, destination: destination);

    PolylinePoints polylinePoints = PolylinePoints();

    List<LatLng> points = getDecodedRoute(polylinePoints, routes);

    return points;
  }

  List<LatLng> getDecodedRoute(
      PolylinePoints polylinePoints, RoutesModel routes) {
    List<PointLatLng> result = polylinePoints.decodePolyline(
      routes.routes!.first.polyline!.encodedPolyline!,
    );

    List<LatLng> points = result
        .map(
          (e) => LatLng(
            e.latitude,
            e.longitude,
          ),
        )
        .toList();
    return points;
  }

  void displayPoints(List<LatLng> points,
      {required Set<Polyline> polylines,
      required GoogleMapController googleMapController}) {
    Polyline route = Polyline(
      color: Colors.blue,
      width: 5,
      polylineId: const PolylineId("Route"),
      points: points,
    );

    LatLngBounds bounds = getLatLngBounds(points);
    googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        35,
      ),
    );

    polylines.add(route);
  }

  LatLngBounds getLatLngBounds(List<LatLng> points) {
    var southWestLatitude = points.first.latitude;
    var southWestLongitude = points.first.longitude;
    var northEastLatitude = points.first.latitude;
    var northEastLongitude = points.first.longitude;

    for (var point in points) {
      southWestLatitude = min(southWestLatitude, point.latitude);
      southWestLongitude = min(southWestLongitude, point.longitude);
      northEastLatitude = max(northEastLatitude, point.latitude);
      northEastLongitude = max(northEastLongitude, point.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(
        southWestLatitude,
        southWestLongitude,
      ),
      northeast: LatLng(
        northEastLatitude,
        northEastLongitude,
      ),
    );
  }

  Future<LatLng> updateCurrentLocation(
      {required GoogleMapController googleMapController,
      required Set<Marker> markers}) async {
    var locationData = await locationService.getLocation();

    var currentLocation = LatLng(
      locationData.latitude!,
      locationData.longitude!,
    );
    Marker currentLocationMarker = Marker(
      markerId: const MarkerId(
        "MyLocation",
      ),
      position: currentLocation,
    );
    CameraPosition cameraPosition = CameraPosition(
      target: currentLocation,
      zoom: 16,
    );
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );
    markers.add(currentLocationMarker);

    return currentLocation;
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    return await placesService.getPlaceDetails(
      placeId: placeId,
    );
  }
}
