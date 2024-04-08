import 'dart:convert';

import 'package:google_maps_udemy/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:google_maps_udemy/models/place_details_model/place_details_model.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  final String baseUrl = "https://maps.googleapis.com/maps/api/place";
  final String apiKey = "AIzaSyDLqTVjw-0gfJNAO4J4CKeTtKvlGV-5c7s";

  Future<List<PlaceModel>> getPredictions({required String input , required String session}) async {
    var response = await http.get(
      Uri.parse("$baseUrl/autocomplete/json?key=$apiKey&input=$input&sessiontoken=$session"),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['predictions'];

      List<PlaceModel> places = [];

      for (var item in data) {
        places.add(
          PlaceModel.fromJson(item),
        );
      }
      return places;
    } else {
      throw Exception();
    }
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    var response = await http.get(
      Uri.parse("$baseUrl/details/json?key=$apiKey&place_id=$placeId"),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['result'];

      return PlaceDetailsModel.fromJson(data);
    } else {
      throw Exception();
    }
  }
}
