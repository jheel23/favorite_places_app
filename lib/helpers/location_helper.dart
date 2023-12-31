import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_API_KEY = 'AIzaSyDLtLRPiWsT9yN47QOZqEqHW4CfYXo1dwg';

class LocationHelper {
  static String generateImagePreview(double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:J%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY");
    final response = await http.get(url);
    //[0]--> means most accurate data that google found
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
