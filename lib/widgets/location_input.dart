import 'package:favorite_places_app/helpers/location_helper.dart';
import 'package:favorite_places_app/pages/maps_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput(this.onSelectPlace);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl = '';
  var _isLocationLoading = false;
  //To show preview of the location inside the container we made-->
  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateImagePreview(lat, lng);
    setState(() {
      _isLocationLoading = false;
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<Position> _getCurrentUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    setState(() {
      _isLocationLoading = true;
    });
    try {
      final userlocation = await Geolocator.getCurrentPosition();
      _showPreview(userlocation.latitude, userlocation.longitude);
      widget.onSelectPlace(userlocation.latitude, userlocation.longitude);
      return userlocation;
    } catch (error) {
      return Future.error('Could not fetch location');
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        //Special type of page that takes over the entire screen
        fullscreenDialog: true,
        builder: (ctx) => MapPage(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          child: _isLocationLoading
              ? CircularProgressIndicator()
              : _previewImageUrl == ''
                  ? Center(child: Text('No Location Chosen'))
                  : Image.network(
                      _previewImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
