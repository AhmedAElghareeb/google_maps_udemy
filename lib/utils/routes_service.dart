import 'dart:convert';

import 'package:google_maps_udemy/models/location_info/location_info.dart';
import 'package:google_maps_udemy/models/routes_model/routes_model.dart';
import 'package:google_maps_udemy/models/routes_modifiers.dart';
import 'package:http/http.dart' as http;

class RoutesService {
  final String baseUrl =
      "https://routes.googleapis.com/directions/v2:computeRoutes";

  final String apiKey = "AIzaSyDLqTVjw-0gfJNAO4J4CKeTtKvlGV-5c7s";

  Future<RoutesModel> fetchRoutes({
    required LocationInfoModel origin,
    required LocationInfoModel destination,
    RoutesModifiers? routesModifiers,
  }) async {
    Uri url = Uri.parse(baseUrl);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
      "X-Goog-FieldMask":
          "routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline",
    };

    Map<String, dynamic> body = {
      "origin": origin.toJson(),
      "destination": destination.toJson(),
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "computeAlternativeRoutes": false,
      "routeModifiers": routesModifiers != null
          ? routesModifiers.toJson()
          : RoutesModifiers().toJson(),
      "languageCode": "en-US",
      "units": "IMPERIAL"
    };

    var response = await http.post(
      url,
      body: jsonEncode(body),
      headers: header,
    );

    if (response.statusCode == 200) {
      return RoutesModel.fromJson(
        jsonDecode(
          response.body,
        ),
      );
    } else {
      throw Exception(
        "No Routes Found",
      );
    }
  }
}
