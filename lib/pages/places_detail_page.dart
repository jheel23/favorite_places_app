import 'dart:io';

import 'package:favorite_places_app/pages/maps_page.dart';
import 'package:favorite_places_app/providers/user_places.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceDetailPage extends StatelessWidget {
  static const routeName = '/place-detail-page';

  @override
  Widget build(BuildContext context) {
    final dataid = ModalRoute.of(context)!.settings.arguments as String;
    final selectedPlace =
        Provider.of<UserPlaces>(context, listen: false).findById(dataid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Detail'),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              File(selectedPlace.image.path),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            selectedPlace.title,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (ctx) => MapPage(
                          initialLocation: selectedPlace.location,
                        )),
              );
            },
            icon: const Icon(Icons.map),
            label: const Text('View on Map'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.black,
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
