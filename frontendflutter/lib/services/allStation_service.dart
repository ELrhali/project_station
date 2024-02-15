import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_marker/services/station_manger.dart';

class AllStationService {
  static Future<void> toutesLesStations() async {
    String apiUrl = 'http://192.168.100.5:8082';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> stations =
            List<Map<String, dynamic>>.from(data['stations']);

        // Stockez la liste dans le gestionnaire de stations
        StationManager().setAllStations(stations);
      } else {
        throw Exception(
            'Erreur lors de la récupération de toutes les stations');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Erreur lors de la récupération de toutes les stations');
    }
  }
}
