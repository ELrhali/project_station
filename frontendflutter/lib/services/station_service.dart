import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_marker/services/auth_service.dart';

class StationService {
  static Future<List<Map<String, dynamic>>> trouverStationsGazole(
      String city) async {
    try {
      String apiUrl = 'http://192.168.100.5:8085/stations/stations/$city';

      AuthService authService =
          AuthService(); // Create an instance of AuthService
      String? token = await authService.getToken();

      if (token != null) {
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Authorization':
                'Bearer $token', // Include the authorization header
          },
        );

        if (response.statusCode == 200) {
          // Decode the response and extract the list of stations
          Map<String, dynamic> data = json.decode(response.body);
          print(data);
          List<Map<String, dynamic>> stations =
              List<Map<String, dynamic>>.from(data['stations']);
          // print("stationdata");
          // print(stations);

          return stations;
        } else {
          throw Exception('Erreur lors de la récupération des stations');
        }
      } else {
        throw Exception('Erreur: Token not available');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Erreur lors de la récupération des stations catch');
    }
  }
}
