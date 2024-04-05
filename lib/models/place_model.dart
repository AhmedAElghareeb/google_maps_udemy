import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;

  PlaceModel({
    required this.id,
    required this.name,
    required this.latLng,
  });
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name: "معرض جدد وافرش بيتك",
    latLng: const LatLng(
      31.062582085583188,
      31.409294777621582,
    ),
  ),
  PlaceModel(
    id: 2,
    name: "مطبعة استار لايت",
    latLng: const LatLng(
        31.06175761871595,
        31.407005790388748,
    ),
  ),
  PlaceModel(
    id: 3,
    name: "Iphone Service",
    latLng: const LatLng(
      31.058220238473474,
      31.403176412353922,
    ),
  ),
];
