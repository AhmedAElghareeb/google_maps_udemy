import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/place_autocomplete_model/place_autocomplete_model.dart';
import '../models/place_details_model/place_details_model.dart';
import '../utils/map_services.dart';

class ResultListView extends StatelessWidget {
  const ResultListView({
    super.key,
    required this.places,
    required this.onPlaceSelect,
    required this.mapServices,
    // required this.mapServices,
    // required this.onPlaceSelect,
  });

  final List<PlaceModel> places;


  final void Function(PlaceDetailsModel) onPlaceSelect;

  final MapServices mapServices;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(places[index].description!),
            leading: const Icon(FontAwesomeIcons.mapPin),
            trailing: IconButton(
              onPressed: () async {
                var placeDetails = await mapServices.getPlaceDetails(
                    placeId: places[index].placeId!);
                onPlaceSelect(placeDetails);
              },
              icon: const Icon(Icons.arrow_circle_right_outlined),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 0,
          );
        },
        itemCount: places.length,
      ),
    );
  }
}
