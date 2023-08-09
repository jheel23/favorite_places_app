import 'package:favorite_places_app/helpers/db_helper.dart';
import 'package:favorite_places_app/models/places.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../helpers/location_helper.dart';

class UserPlaces with ChangeNotifier {
  List<Places> _places = [];
  //Copy-->
  List<Places> get places {
    return [..._places];
  }

  Places findById(String id) {
    return _places.firstWhere((element) => element.id == id);
  }

  Future<void> addPlace(String pickedTitle, File? pickedImage,
      PlaceLocation pickedLocation) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );
    final newPlace = Places(
      id: DateTime.now().toString(),
      image: pickedImage!,
      title: pickedTitle,
      location: updatedLocation,
    );
    _places.add(newPlace);
    notifyListeners();
    DBHelper.insertData('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location!.latitude,
      'loc_lng': newPlace.location!.longitude,
      'address': newPlace.location!.address,
    });
  }

  Future<void> fetchAndSetData() async {
    final dataList = await DBHelper.getData('user_places');
    _places = dataList
        .map(
          (item) => Places(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_lng'],
                address: item['address']),
          ),
        )
        .toList();
    notifyListeners();
  }
}
