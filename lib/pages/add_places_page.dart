import 'dart:io' as io;
import 'package:favorite_places_app/models/places.dart';
import 'package:favorite_places_app/providers/user_places.dart';
import 'package:favorite_places_app/widgets/location_input.dart';

import 'package:provider/provider.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'package:flutter/material.dart';

class AddPlacesPage extends StatefulWidget {
  const AddPlacesPage({super.key});
  static const routeName = '/add-places-page';

  @override
  State<AddPlacesPage> createState() => _AddPlacesPageState();
}

class _AddPlacesPageState extends State<AddPlacesPage> {
  final _titleController = TextEditingController();
  io.File? _pickedImage;
  PlaceLocation? _pickedLocation;
  void _selectImage(io.File image) {
    _pickedImage = image;
  }

  void _selectLocation(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }
    Provider.of<UserPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage!, _pickedLocation!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final appBar = AppBar();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Place'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    const SizedBox(height: 10),
                    ImageInput(_selectImage),
                    const SizedBox(height: 10),
                    LocationInput(_selectLocation)
                  ],
                ),
              )),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add_location),
                label: const Text('Add Place'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
