import 'package:favorite_places_app/pages/add_places_page.dart';
import 'package:favorite_places_app/pages/places_detail_page.dart';
import 'package:favorite_places_app/providers/user_places.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlacesPage.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<UserPlaces>(context, listen: false).fetchAndSetData(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<UserPlaces>(
                child: Center(
                  child: const Text('No places added yet!'),
                ),
                builder: (ctx, userplacesdata, ch) =>
                    userplacesdata.places.length <= 0
                        ? ch as Widget
                        : ListView.builder(
                            itemCount: userplacesdata.places.length,
                            itemBuilder: (ctx, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(userplacesdata.places[i].image),
                              ),
                              title: Text(userplacesdata.places[i].title),
                              subtitle:
                                  userplacesdata.places[i].location!.address ==
                                          null
                                      ? Text('No Address')
                                      : Text(userplacesdata
                                          .places[i].location!.address!),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  PlaceDetailPage.routeName,
                                  arguments: userplacesdata.places[i].id,
                                );
                              },
                            ),
                          ),
              ),
      ),
    );
  }
}
