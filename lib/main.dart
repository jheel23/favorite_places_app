import 'package:favorite_places_app/pages/add_places_page.dart'
    show AddPlacesPage;

import 'package:favorite_places_app/pages/places_detail_page.dart';
import 'package:favorite_places_app/pages/places_list_page.dart';
import 'package:favorite_places_app/providers/user_places.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: UserPlaces(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Favorite Places',
          theme: ThemeData(
            primaryColor: Colors.indigo,
            canvasColor: Color.fromARGB(255, 191, 200, 249),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: Colors.amber, primary: Colors.indigo),
          ),
          home: PlacesListPage(),
          routes: {
            AddPlacesPage.routeName: (ctx) => AddPlacesPage(),
            PlaceDetailPage.routeName: (ctx) => PlaceDetailPage(),
          }),
    );
  }
}
